module AdminActions
  class AddCollaborator
    attr_reader :form_answer,
      :user,
      :success,
      :errors

    def initialize(form_answer, user)
      @form_answer = form_answer
      @user = user
    end

    def run
      if user.can_be_added_to_collaborators_to_another_account?
        persist!
      else
        @errors = "can't be added as linked with another account!"
      end

      self
    end

    def success?
      @success.present?
    end

    private

    def persist!
      user.role = "regular"
      user.account = form_answer.account

      if user.save
        @success = true
      else
        @errors = user.errors.full_messages.join(", ")
      end
    end
  end
end
