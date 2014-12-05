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
  validates :title, presence: {message: "Title can't be blank"}, :if => :is_first_step?
  validates :first_name, presence: {message: "First name can't be blank"}, :if => :is_first_step?
  validates :last_name, presence: {message: "Last name can't be blank"}, :if => :is_first_step?
  validates :job_title, presence: {message: "Job title can't be blank"}, :if => :is_first_step?
  validates :phone_number, presence: {message: "Telephone number can't be blank"}, :if => :is_first_step?
  
  # Second step validations
  validates :company_name, presence: {message: "Company name can't be blank"}, :if => :is_second_step?
  validates :company_address_first, presence: {message: "First address line can't be blank"}, :if => :is_second_step?
  validates :company_address_second, presence: {message: "Second address line can't be blank"}, :if => :is_second_step?
  validates :company_city, presence: {message: "City can't be blank"}, :if => :is_second_step?
  validates :company_country, presence: {message: "Country can't be blank"}, :if => :is_second_step?
  validates :company_postcode, presence: {message: "Postcode can't be blank"}, :if => :is_second_step?
  validates :company_phone_number, presence: {message: "Telephone number can't be blank"}, :if => :is_second_step?

  validates :company_postcode, length: {
    minimum: 6,
    maximum: 8,
    :too_short => "Please enter a valid postcode.",
    :too_long => "Please enter a valid postcode."
  }, :if => :is_second_step?

  validates :company_postcode, format: {
    with: /[a-zA-Z]{1,2}[0-9][0-9a-zA-Z]?\s?[0-9][a-zA-Z]{2}/,
    :message => "Please enter a valid postcode"
  }, :if => :is_second_step?

  validates :phone_number, length: {
    minimum: 7,
    maximum: 20,
    :too_short => "Please enter  a valid telephone number",
    :too_long => "Please enter a valid telephone number"
  }, :if => :is_first_step?

  validates :company_phone_number, length: {
    minimum: 7,
    maximum: 20,
    :too_short => "Please enter  a valid telephone number",
    :too_long => "Please enter a valid telephone number"
  }, :if => :is_second_step?

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

  def setStep (step)
    @current_step = step
  end

  private

  def is_first_step?
    @current_step == 1
  end

  def is_second_step?
    @current_step == 2
  end

  def password_required?
    new_record? ? super : false
  end

  def create_account
    self.account = Account.create(owner: self) unless account
  end
end
