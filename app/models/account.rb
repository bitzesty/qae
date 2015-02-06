class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :form_answers, dependent: :nullify

  belongs_to :owner, class_name: 'User', autosave: false, inverse_of: :owned_account
  validates :owner, presence: true

  def collaborators_without(user)
    users.excluding(user).by_email
  end

  def has_trade_award?
    form_answers.where(award_type: 'trade').any?
  end
end
