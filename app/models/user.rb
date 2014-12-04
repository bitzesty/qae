class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :agreed_with_privacy_policy

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create

  validates :role, presence: true

  begin :associations
    has_many :form_answers, dependent: :destroy
    has_one :eligibility, dependent: :destroy
    has_one :owned_account, foreign_key: :owner_id, class_name: 'Account'

    belongs_to :account
  end

  before_create :create_account

  enumerize :prefered_method_of_contact, in: %w(phone email)
  enumerize :qae_info_source, in: %w(govuk competitor business_event national_press business_press online local_trade_body national_trade_body mail_from_qae word_of_mouth other)
  enumerize :role, in: %w(account_admin regular)

  private

  def password_required?
    new_record? ? super : false
  end

  def create_account
    self.account = Account.create(owner: self) unless account
  end
end
