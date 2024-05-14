class FormAnswer
  class AwardEligibilityBuilder
    attr_reader :form_answer, :account

    def initialize(form_answer)
      @form_answer = form_answer
      @account = form_answer.user.account
    end

    def eligibility
      method = "#{form_answer.award_type}_eligibility"

      unless form_answer.public_send(method)
        form_answer.public_send(:"build_#{method}", account_id: account.id).save!
      end

      form_answer.public_send(method)
    end

    def basic_eligibility
      @basic_eligibility ||= begin
        return nil if form_answer.promotion?

        if form_answer.form_basic_eligibility.try(:persisted?)
          form_answer.form_basic_eligibility
        else
          form_answer.build_form_basic_eligibility(filter(account.basic_eligibility.try(:attributes) || {}).merge(account_id: account.id)).save!
          form_answer.form_basic_eligibility
        end
      end
    end

    private

    def filter(params)
      params.except("id", "created_at", "updated_at")
    end
  end
end
