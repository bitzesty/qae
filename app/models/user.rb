class User < ActiveRecord::Base
  def after_initialize
    @current_step = 0
  end

  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :agreed_with_privacy_policy
  attr_accessor :current_password

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create

  validates :role, presence: true

  # First step validations
  validates :title, presence: true, if: :first_step?
  validates :first_name, presence: true, if: :first_step?
  validates :last_name, presence: true, if: :first_step?
  validates :job_title, presence: true, if: :first_step?
  validates :phone_number, presence: true, if: :first_step?
  
  # Second step validations
  validates :company_name, presence: true, if: :second_step?
  validates :company_address_first, presence: true, if: :second_step?
  validates :company_address_second, presence: true, if: :second_step?
  validates :company_city, presence: true, if: :second_step?
  validates :company_country, presence: true, if: :second_step?
  validates :company_postcode, presence: true, if: :second_step?
  validates :company_phone_number, presence: true, if: :second_step?

  validates :company_postcode, length: {
    minimum: 6,
    maximum: 8,
    :message => "not a valid postcode."
  }, if: :second_step?

  validates :company_postcode, format: {
    with: /\A[a-zA-Z]{1,2}[0-9][0-9a-zA-Z]?\s?[0-9][a-zA-Z]{2}\z/,
    :message => "not a valid postcode"
  }, if: :second_step?

  validates :phone_number, length: {
    minimum: 7,
    maximum: 20,
    :message => "not a valid telephone number"
  }, if: :first_step?

  validates :company_phone_number, length: {
    minimum: 7,
    maximum: 20,
    message: "not a valid telephone number"
  }, if: :second_step?

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

  def set_step (step)
    @current_step = step
  end

  private

  def first_step?
    @current_step == 1
  end

  def second_step?
    @current_step == 2
  end

  def password_required?
    new_record? ? super : false
  end

  def create_account
    self.account = Account.create(owner: self) unless account
  end
end
