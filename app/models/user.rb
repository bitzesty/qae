class User < ActiveRecord::Base
  POSSIBLE_ROLES = %w(account_admin regular)

  def after_initialize
    @current_step = 0
  end

  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

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
  validates :company_city, presence: true, if: :second_step?
  validates :company_country, presence: true, if: :second_step?
  validates :company_postcode, presence: true, if: :second_step?
  validates :company_phone_number, presence: true, if: :second_step?

  validates :phone_number, length: {
    minimum: 7,
    maximum: 20,
    :message => "This is not a valid telephone number"
  }, if: :first_step?

  validates :company_phone_number, length: {
    minimum: 7,
    maximum: 20,
    message: "This is not a valid telephone number"
  }, if: :second_step?

  begin :associations
    has_many :form_answers, dependent: :destroy
    has_many :eligibilities, dependent: :destroy
    has_one :basic_eligibility, class_name: 'Eligibility::Basic'
    has_one :trade_eligibility, class_name: 'Eligibility::Trade'
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation'
    has_one :development_eligibility, class_name: 'Eligibility::Development'
    has_one :promotion_eligibility, class_name: 'Eligibility::Promotion'
    has_one :owned_account, foreign_key: :owner_id, class_name: 'Account'

    belongs_to :account
  end

  begin :scopes
    scope :excluding, -> (user) { 
      where.not(id: user.id) 
    }
    scope :by_email, -> { order(:email) }
  end

  before_create :create_account

  enumerize :prefered_method_of_contact, in: %w(phone email)
  enumerize :qae_info_source, in: %w(govuk competitor business_event national_press business_press online local_trade_body national_trade_body mail_from_qae word_of_mouth other)
  enumerize :role, in: POSSIBLE_ROLES, predicates: true

  def set_step (step)
    @current_step = step
  end

  private

  def first_step?
    @current_step && @current_step >= 1
  end

  def second_step?
    @current_step && @current_step >= 2
  end

  def password_required?
    new_record? ? super : false
  end

  def create_account
    self.account = Account.create(owner: self) unless account
  end
end
