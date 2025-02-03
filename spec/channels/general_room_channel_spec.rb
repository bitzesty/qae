require "rails_helper"

describe GeneralRoomChannel, type: :channel do
  let(:channel_name) { "presence-chat-development-1-general" }
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:current_tab) { "anything" }

  before do
    stub_connection
    allow(Collaborators::BroadcastCollabWorker).to receive(:perform_async)
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end

  describe "#subscribed" do
    context "when the room is empty" do
      it "adds the subscribing user ID to the redis cache" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })

        expect(Rails.cache.read(channel_name)).to eq(["#{user.id}-#{current_tab}"])
      end

      it "broadcasts the new room member" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, ["#{user.id}-#{current_tab}"])

        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })
      end
    end

    context "when the room already has a member" do
      before do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })
      end

      let(:user_two_tab) { "anything-else" }

      it "adds the subscribing user ID to the redis cache" do
        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => user_two_tab })

        expect(Rails.cache.read(channel_name)).to eq(["#{user.id}-#{current_tab}", "#{user_two.id}-#{user_two_tab}"])
      end

      it "broadcasts the new room member" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, ["#{user.id}-#{current_tab}", "#{user_two.id}-#{user_two_tab}"])

        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => user_two_tab })
      end
    end
  end

  describe "#unsubscribed" do
    context "when there is one room member" do
      it "clears the room" do
        sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })

        sub_one.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq []
      end

      it "broadcasts the new (empty) room members" do
        sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })

        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [])
        sub_one.unsubscribe_from_channel
      end
    end

    context "when there are multiple room members" do
      let(:user_two_tab) { "anything-else" }

      it "removes only the unsubscribing room member" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => current_tab })
        sub_two = subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => user_two_tab })

        expect(Rails.cache.read(channel_name)).to eq(["#{user.id}-#{current_tab}", "#{user_two.id}-#{user_two_tab}"])

        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, ["#{user.id}-#{current_tab}"])

        sub_two.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq(["#{user.id}-#{current_tab}"])
      end
    end
  end
end
