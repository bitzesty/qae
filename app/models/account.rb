class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :form_answers, dependent: :nullify

  has_many :eligibilities, dependent: :destroy
  has_many :basic_eligibilities, class_name: "Eligibility::Basic"
  has_many :trade_eligibilities, class_name: "Eligibility::Trade"
  has_many :innovation_eligibilities, class_name: "Eligibility::Innovation"
  has_many :development_eligibilities, class_name: "Eligibility::Development"
  has_many :mobility_eligibilities, class_name: "Eligibility::Mobility"
  has_many :promotion_eligibilities, class_name: "Eligibility::Promotion"

  belongs_to :owner, class_name: "User", autosave: false, inverse_of: :owned_account, optional: true
  validates :owner, presence: true

  def basic_eligibility
    basic_eligibilities.first
  end

  def collaborators_with(user)
    users.confirmed.to_a.prepend(user).uniq.reject { |c| c.blank? }
  end

  def collaborators_without(user)
    users.not_including(user).by_email
  end

  def has_collaborators?
    users.count > 1
  end

  def has_no_collaborators?
    !has_collaborators?
  end

  def other_submitted_applications(excluded_form_answer)
    form_answers.submitted.where.not(id: excluded_form_answer.id).joins(:award_year).order("award_years.year DESC")
  end

  def has_award_in_this_year?(award_type)
    form_answers.for_year(AwardYear.current.year.to_s)
                 .for_award_type(award_type)
                 .present?
  end

  def collaborators_checked?
    collaborators_checked_at && collaborators_checked_at > Time.zone.now - 6.months
  end
end
