require "rails_helper"

RSpec.describe GeneralRoomChannel, type: :channel do
  let(:channel_name) { "presence-chat-development-1-general" }
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }

  before do
    stub_connection
    allow(Collaborators::BroadcastCollabWorker).to receive(:perform_async)
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end

  describe "#subscribed" do
    context "when the room is empty" do
      it "adds the subscribing user ID to the redis cache" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })

        expect(Rails.cache.read(channel_name)).to eq([user.id.to_s])
      end

      it "broadcasts the new room member" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [user.id.to_s])

        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })
      end
    end

    context "when the room already has a member" do
      before do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })
      end

      it "adds the subscribing user ID to the redis cache" do
        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s })

        expect(Rails.cache.read(channel_name)).to eq([user.id.to_s, user_two.id.to_s])
      end

      it "broadcasts the new room member" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [user.id.to_s, user_two.id.to_s])

        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s })
      end
    end
  end

  describe "#unsubscribed" do
    context "when there is one room member" do
      it "clears the room" do
        sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })

        sub_one.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq []
      end

      it "broadcasts the new (empty) room members" do
        sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })

        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [])
        sub_one.unsubscribe_from_channel
      end
    end

    context "when there are multiple room members" do
      it "removes only the unsubscribing room member" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s })
        sub_two = subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s })

        expect(Rails.cache.read(channel_name)).to eq([user.id.to_s, user_two.id.to_s])

        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [user.id.to_s])

        sub_two.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq([user.id.to_s])
      end
    end
  end
end
