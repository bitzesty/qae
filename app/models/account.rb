class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :form_answers, dependent: :nullify

  has_many :eligibilities, dependent: :destroy
  has_one :basic_eligibility, class_name: 'Eligibility::Basic'
  has_one :trade_eligibility, class_name: 'Eligibility::Trade'
  has_one :innovation_eligibility, class_name: 'Eligibility::Innovation'
  has_one :development_eligibility, class_name: 'Eligibility::Development'
  has_one :promotion_eligibility, class_name: 'Eligibility::Promotion'

  belongs_to :owner, class_name: 'User', autosave: false, inverse_of: :owned_account
  validates :owner, presence: true

  def collaborators_without(user)
    users.excluding(user).by_email
  end

  def has_trade_award?
    form_answers.where(award_type: 'trade').any?
  end
end
