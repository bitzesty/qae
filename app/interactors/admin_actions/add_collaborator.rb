module AdminActions
  class AddCollaborator
    attr_reader :account, :role, :transfer_form_answers, :new_owner_id, :collaborator, :success, :errors

    def initialize(account:, collaborator:, params:, existing_account: collaborator.account)
      @account = account
      @collaborator = collaborator
      @existing_account = existing_account
      @role = params.fetch(:role, "regular")
      @transfer_form_answers = params.fetch(:transfer_form_answers, false)
      @new_owner_id = params.fetch(:new_owner_id, nil)
      @errors = []
    end

    def run
      if account_will_be_orphaned?
        @errors << "User account has active users, ownership of the account must be transferred"
      elsif progressed_form_answers_will_be_orphaned?
        @errors << "User has applications in progress, and there are no other users on the account to transfer them to"
      else
        persist!
      end

      self
    end

    def success?
      @success.present?
    end

    def error_messages
      @errors.join(", ")
    end

    private

    def persist!
      ActiveRecord::Base.transaction do
        transfer_collaborator!
        transfer_ownership!
        handle_form_answers!
        delete_existing_account!
        @success = true
      end
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
    end

    def existing_account_has_other_collaborators?
      return unless @existing_account

      @existing_account.collaborators_without(collaborator).any?
    end

    def account_will_be_orphaned?
      collaborator_is_owner? && existing_account_has_other_collaborators? && new_owner_id.blank?
    end

    def collaborator_is_owner?
      return unless @existing_account

      @existing_account.owner == collaborator
    end

    def progressed_form_answers_will_be_orphaned?
      keep_form_answers_on_original_account? && progressed_form_answers? && !existing_account_has_other_collaborators?
    end

    def progressed_form_answers?
      collaborator.form_answers.any? && collaborator.form_answers.any?(&:any_progress?)
    end

    def transfer_form_answers?
      transfer_form_answers
    end

    def keep_form_answers_on_original_account?
      !transfer_form_answers?
    end

    def handle_form_answers!
      return unless @collaborator.form_answers.any?

      if transfer_form_answers?
        @collaborator.form_answers.each { |f| f.update!(account: @account) }
      elsif existing_account_has_other_collaborators?
        @collaborator.form_answers.each { |f| f.update!(user: @existing_account.owner) }
      elsif !progressed_form_answers?
        @collaborator.form_answers.each(&:destroy!)
      end
    end

    def transfer_ownership!
      return unless @new_owner_id

      @existing_account.update!(owner_id: @new_owner_id)
    end

    def transfer_collaborator!
      collaborator.update!(role: role, account: account)
    end

    def delete_existing_account!
      return unless @existing_account
      return if existing_account_has_other_collaborators?

      @existing_account.destroy!
    end
  end
end
