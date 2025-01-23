require "rails_helper"

describe CollaboratorsChannel, type: :channel do
  let(:channel_name) { "presence-chat-development-1-sep-step-consent-due-diligence" }
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:tab_one) { "EiIKeLF" }
  let(:tab_two) { "isdSJa2" }
  let(:current_editor) { { email: user.email, id: user.id.to_s, name: user.full_name, tab_ident: tab_one }.stringify_keys }

  before do
    stub_connection
    allow(Collaborators::BroadcastCollabWorker).to receive(:perform_async)
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end

  describe "#subscribed" do
    context "when there are no subscribed users" do
      before do
        Rails.cache.write(channel_name, [])
      end

      it "makes the first joining user an editor" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })

        expect(Rails.cache.read(channel_name)).to eq([current_editor])
      end

      it "broadcasts the collaborators for the room" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [current_editor])

        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
      end
    end

    context "when there is already an editor for the channel" do
      let(:second_user_tab) { "2392j123" }
      before do
        Rails.cache.write(channel_name, [current_editor])
      end

      it "adds the second user as a non-editor" do
        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => second_user_tab })

        expect(Rails.cache.read(channel_name)).to eq(
          [
            current_editor,
            { email: user_two.email, id: user_two.id.to_s, name: user_two.full_name, tab_ident: second_user_tab }.stringify_keys,
          ],
        )
      end

      it "broadcasts the collaborators for the room" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(
          channel_name,
          [current_editor, { email: user_two.email, id: user_two.id.to_s, name: user_two.full_name, tab_ident: second_user_tab }.stringify_keys],
        )

        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id, "current_tab" => second_user_tab })
      end
    end

    context "when the same user opens two tabs" do
      it "adds the same user to the cache but as a non-editor" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_two })

        expect(Rails.cache.read(channel_name)).to eq([
          current_editor,
          { email: user.email, id: user.id.to_s, name: user.full_name, tab_ident: tab_two }.stringify_keys,
        ])
      end
    end
  end

  describe "#unsubscribed" do
    context "when the editor leaves the channel" do
      before do
        Rails.cache.write(channel_name, [])
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
      end

      it "removes the user from the redis cache" do
        expect(subscription).to be_confirmed
        subscription.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq []
      end

      it "broadcasts the new collaborator list" do
        expect(Collaborators::BroadcastCollabWorker).to receive(:perform_async).with(channel_name, [])

        subscription.unsubscribe_from_channel
      end
    end

    context "when the editor leaves the channel and another user is present" do
      before do
        Rails.cache.write(channel_name, [])
      end

      it "makes the second user the new editor" do
        sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
        subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => tab_two })

        expect(Rails.cache.read(channel_name)).to eq([
          current_editor,
          { email: user_two.email, id: user_two.id.to_s, name: user_two.full_name, tab_ident: tab_two }.stringify_keys,
        ])

        sub_one.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq([
          { email: user_two.email, id: user_two.id.to_s, name: user_two.full_name, tab_ident: tab_two }.stringify_keys,
        ])
      end
    end

    context "when a non-editor leaves the channel" do
      it "keeps the editor the same as before" do
        subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
        sub_two = subscribe({ "channel_name" => channel_name, "user_id" => user_two.id.to_s, "current_tab" => tab_two })

        sub_two.unsubscribe_from_channel

        expect(Rails.cache.read(channel_name)).to eq([current_editor])
      end
    end

    context "when one user has two tabs open" do
      context "and they close the editor tab" do
        it "makes the non-editing tab the editor" do
          sub_one = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
          subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_two })

          sub_one.unsubscribe_from_channel

          expect(Rails.cache.read(channel_name)).to eq([
            { email: user.email, id: user.id.to_s, name: user.full_name, tab_ident: tab_two }.stringify_keys,
          ])
        end
      end

      context "and they close the non-editor tab" do
        it "keeps the editing tab as the editor" do
          subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_one })
          sub_two = subscribe({ "channel_name" => channel_name, "user_id" => user.id.to_s, "current_tab" => tab_two })

          sub_two.unsubscribe_from_channel

          expect(Rails.cache.read(channel_name)).to eq([
            { email: user.email, id: user.id.to_s, name: user.full_name, tab_ident: tab_one }.stringify_keys,
          ])
        end
      end
    end
  end
end
