# Use this class when you need easily populate form answers for testing
# from existing
#
# Use:
# form_answer = FormAnswer.find(1)
# DemoFormsPopulator.new(form_answer).populate

class DemoFormsPopulator
  attr_accessor :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def populate
    30.times do |i|
      y = i + 1
      new_form = form_answer.amoeba_dup

      user = User.find_by_email("test_#{y}@example.com")

      unless user.present?
        pass = SecureRandom.hex

        user = User.new(
          email: "test_#{y}@example.com",
          title: "test_#{y}_title",
          first_name: "John #{y}",
          last_name: "Doe #{y}",
          job_title: "Manager",
          phone_number: "1298312#{y}#{rand(1..10)}",
          password: pass,
          password_confirmation: pass
        )
        user.skip_confirmation!

        user.save(validate: false)
        user.update_column(:confirmed_at, Time.zone.now - 3.days)

        Account.create(owner: user)
        user.reload
      end

      new_form.user_id = user.id
      new_form.company_or_nominee_name = "DEMO Company #{form_answer.award_type} #{y}"
      new_form.account_id = user.account.id
      new_form.company_details_editable_id = nil
      new_form.company_details_editable_type = nil
      new_form.primary_assessor_id = nil
      new_form.secondary_assessor_id = nil
      new_form.urn = nil
      new_form.save(validate: false)

      new_form.reload

      builder = UrnBuilder.new(new_form)
      builder.assign
    end
  end
end
