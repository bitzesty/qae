# Run:
# AdditionalEpStats.new.run

class AdditionalEpStats
  attr_accessor :all_forms,
                :all_forms_count,
                :submitted_forms,
                :submitted_forms_count,
                :not_submitted_forms,
                :not_submitted_forms_count,
                :not_submitted_with_at_least_of_one_support_letter,
                :not_submitted_with_at_least_of_one_support_letter_count,
                :not_submitted_with_at_least_of_one_support_letter_ids,
                :not_submitted_without_support_letters,
                :not_submitted_without_support_letters_count,
                :eligible_but_not_submitted,
                :eligible_but_not_submitted_count,
                :with_one_support_letter,
                :with_one_support_letter_count,
                :with_one_support_letter_ids

  def initialize
    self.all_forms = FormAnswer.promotion
    self.all_forms_count = all_forms.count

    self.submitted_forms = all_forms.submitted
    self.submitted_forms_count = submitted_forms.count

    self.not_submitted_forms = all_forms.where(submitted: false)
    self.not_submitted_forms_count = not_submitted_forms.count

    self.eligible_but_not_submitted = not_submitted_forms.where(state: "application_in_progress")
                                                         .select { |f| f.eligible? }
    self.eligible_but_not_submitted_count = eligible_but_not_submitted.count

    self.not_submitted_with_at_least_of_one_support_letter = eligible_but_not_submitted.select do |f|
      f.support_letters.present?
    end

    self.with_one_support_letter = eligible_but_not_submitted.select do |f|
      f.support_letters.count == 1
    end
    self.with_one_support_letter_count = with_one_support_letter.count
    self.with_one_support_letter_ids = with_one_support_letter.map(&:id)

    self.not_submitted_without_support_letters = eligible_but_not_submitted.select do |f|
      f.support_letters.blank?
    end
    self.not_submitted_without_support_letters_count = not_submitted_without_support_letters.count
    self.not_submitted_with_at_least_of_one_support_letter_count = not_submitted_with_at_least_of_one_support_letter.count
    self.not_submitted_with_at_least_of_one_support_letter_ids = not_submitted_with_at_least_of_one_support_letter.map(&:id)
  end

  def run
    log_this("all: #{all_forms_count}")
    log_this("submitted: #{submitted_forms_count}")

    log_this("not submitted: #{not_submitted_forms_count}")
    log_this("eligible, but not submitted: #{eligible_but_not_submitted_count}")

    log_this("how many received only 1 letter of support: #{with_one_support_letter_count}")
    log_this("how many received only 1 letter of support ids: #{with_one_support_letter_ids}")
    log_this("how many received none: #{not_submitted_without_support_letters_count}")
    log_this("how many did not complete the form (i.e they gave up before requesting letters of support) #{not_submitted_without_support_letters_count}")
  end

  private

  def log_this(m)
    m = "[EP Stats] #{m}"
    puts m
  end
end
