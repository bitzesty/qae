require "rails_helper"

describe AdminActions::AddCollaborator do
  describe "#run" do
    let(:result) { described_class.new(account:, collaborator:, params:, existing_account:).run }
    let(:account) { create(:account) }
    let(:collaborator) { create(:user, form_answers: form_answers, account: collaborator_account, role: "regular") }
    let(:existing_account) { collaborator.account }
    let(:collaborator_account) { create(:account) }
    let(:collaborator_account_other_users) { [] }
    let(:form_answers) { [] }
    let(:params) { { role: role, transfer_form_answers: transfer_form_answers, new_owner_id: new_owner_id } }
    let(:role) { "account_admin" }
    let(:new_owner_id) { nil }

    context "when transfer_form_answers is true" do
      let(:transfer_form_answers) { true }

      context "when the collaborator has form_answers" do
        let(:form_answers) { create_list(:form_answer, 3) }

        context "when the collaborator_account has no other users" do
          it "transfers the collaborator and form_answers, and the collaborator account is deleted" do
            expect(result).to be_success
            expect(collaborator.account).to eq(account)
            expect(collaborator.role).to eq(role)
            expect { collaborator_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
            form_answers.each { |f| expect(f.account).to eq(account) }
          end
        end

        context "when the collaborator_account has other users" do
          let!(:collaborator_account_other_users) { create_list(:user, 2, account: collaborator_account) }
          let(:new_owner_id) { collaborator_account_other_users.first.id }

          it "transfers the collaborator and form_answers, and ownership of the collaborator account is transferred" do
            expect(result).to be_success
            expect(collaborator.account).to eq(account)
            expect(collaborator.role).to eq(role)
            expect(collaborator_account.owner).to eq(collaborator_account_other_users.first)
            expect(collaborator_account.users).not_to include(collaborator)
            form_answers.each { |f| expect(f.account).to eq(account) }
          end
        end
      end
    end

    context "when transfer_form_answers is false" do
      let(:transfer_form_answers) { false }

      context "when the existing_account is nil" do
        let(:existing_account) { nil }

        it "transfers the collaborator" do
          expect(result).to be_success
          expect(collaborator.account).to eq(account)
          expect(collaborator.role).to eq(role)
        end
      end

      context "when the collaborator does not have form_answers" do
        let(:form_answers) { [] }

        it "transfers the collaborator and the collaborator account is deleted" do
          expect(result).to be_success
          expect(collaborator.account).to eq(account)
          expect(collaborator.role).to eq(role)
          expect { collaborator_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        context "when the collaborator is the owner of the account" do
          before do
            collaborator_account.owner = collaborator
            collaborator_account.save
          end

          it "transfers the collaborator and the collaborator account is deleted" do
            expect(result).to be_success
            expect(collaborator.account).to eq(account)
            expect(collaborator.role).to eq(role)
            expect { collaborator_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when the collaborator_account has other users" do
          let!(:collaborator_account_other_users) { create_list(:user, 2, account: collaborator_account) }

          it "transfers the collaborator and the collaborator account is not deleted" do
            expect(result).to be_success
            expect(collaborator.account).to eq(account)
            expect(collaborator.role).to eq(role)
            expect(collaborator_account.users).to eq(collaborator_account_other_users)
          end

          context "when the collaborator is the owner of the account" do
            let(:new_owner_id) { collaborator_account_other_users.first.id }

            before do
              collaborator_account.owner = collaborator
              collaborator_account.save
            end

            it "transfers the collaborator and ownership of the collaborator_account" do
              expect(result).to be_success
              expect(collaborator.account).to eq(account)
              expect(collaborator.role).to eq(role)
              expect(collaborator_account.owner).to eq(collaborator_account_other_users.first)
              expect(collaborator_account.users).not_to include(collaborator)
            end

            context "when the new_owner_id is not specified" do
              let(:new_owner_id) { nil }

              it "is not a success" do
                expect(result).not_to be_success
                expect(result.error_messages)
                  .to eq("User account has active users, ownership of the account must be transferred")
                expect(collaborator.account).to eq(collaborator_account)
              end
            end

            context "when an invalid new_owner_id is specified" do
              let(:new_owner_id) { 1000 }

              it "is not a success" do
                expect(result).not_to be_success
                expect(result.error_messages)
                  .to eq("Validation failed: Owner Owner is empty - it is a required field and must be filled in")
                expect(collaborator.reload.account).to eq(collaborator_account)
              end
            end
          end
        end
      end
      context "when the collaborator has form_answers" do
        let(:form_answers) { create_list(:form_answer, 3) }

        context "when the collaborator_account has no other users" do
          it "transfers the collaborator, and the collaborator account and form_answers are deleted" do
            expect(result).to be_success
            expect(collaborator.account).to eq(account)
            expect(collaborator.role).to eq(role)
            expect { collaborator_account.reload }.to raise_error(ActiveRecord::RecordNotFound)
            form_answers.each { |f| expect { f.reload }.to raise_error(ActiveRecord::RecordNotFound) }
          end
        end

        context "when the form_answers are in progress" do
          let(:form_answers) { create_list(:form_answer, 3, :development) }

          context "when the collaborator_account has other users" do
            let!(:collaborator_account_other_users) { create_list(:user, 2, account: collaborator_account) }

            context "when the new_owner_id is specified" do
              let(:new_owner_id) { collaborator_account_other_users.first.id }

              it "transfers the collaborator and ownership of the form_answers to the new owner" do
                expect(result).to be_success
                expect(collaborator.account).to eq(account)
                expect(collaborator.role).to eq(role)
                expect(collaborator_account.owner).to eq(collaborator_account_other_users.first)
                form_answers.each { |f| expect(f.user).to eq(collaborator_account_other_users.first) }
                expect(collaborator_account.users).not_to include(collaborator)
              end
            end

            context "when the new_owner_id is not specified" do
              let(:new_owner_id) { nil }

              before do
                collaborator_account.owner = collaborator_account_other_users.first
                collaborator_account.save
              end

              it "transfers the collaborator and ownership of the form_answers to the existing owner" do
                expect(result).to be_success
                expect(collaborator.account).to eq(account)
                expect(collaborator.role).to eq(role)
                expect(collaborator_account.users).not_to include(collaborator)
                form_answers.each { |f| expect(f.user).to eq(collaborator_account_other_users.first) }
              end
            end
          end

          context "when the collaborator_account has no other users" do
            it "is not a success" do
              expect(result).not_to be_success
              expect(result.error_messages)
                .to eq("User has applications in progress, and there are no other users on the account to transfer them to")
              expect(collaborator.account).to eq(collaborator_account)
            end
          end
        end
      end
    end
  end
end
