class ShortlistedDocumentsWrapper < ActiveRecord::Base
  include Reviewable

  has_one :commercial_figures_file
  has_many :vat_returns_files
  belongs_to :form_answer, optional: true

  validate :valid_for_submission?

  def submit
    self.submitted_at = Time.zone.now
    save
  end

  def submitted?
    submitted_at?
  end

  def no_changes_necessary?
    status == "no_changes_necessary"
  end

  def confirmed_changes?
    status == "confirmed_changes"
  end

  private

  def valid_for_submission?
    return true unless submitted?

    if vat_returns_files.first&.attachment.present?
      true
    else
      errors.add(:base, "You need to add at least one VAT returns file")
      false
    end
  end
end
