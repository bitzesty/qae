class ShortlistedDocumentsWrapper < ActiveRecord::Base
  include Reviewable

  has_one :commercial_figures_file
  has_many :vat_returns_files
  belongs_to :form_answer

  validate :valid_for_submission?

  def complete
    set_submission_date
  end
  alias_method :submit, :complete

  def uncomplete
    set_submission_date(nil)
  end

  def submittable?
    !submitted? && requirements_fulfilled?
  end

  def submitted?
    !submitted_at.nil?
  end

  def no_changes_necessary?
    status == "no_changes_necessary"
  end

  def confirmed_changes?
    status == "confirmed_changes"
  end

  private
  
  def set_submission_date(timestamp = Time.zone.now)
    self.update(submitted_at: timestamp)
  end

  def requirements_fulfilled?
    vat_returns_files.any? { |resource| resource&.attachment.present? }
  end

  def valid_for_submission?
    return true unless submitted?

    if requirements_fulfilled?
      true
    else
      errors.add(:base, "You need to add at least one VAT returns file")
      false
    end
  end
end
