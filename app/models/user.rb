class User < ActiveRecord::Base
  include PgSearch
  extend Enumerize

  POSSIBLE_ROLES = %w(account_admin regular)

  def after_initialize
    @current_step = 0
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :zxcvbnable

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

  validates :phone_number, length: {
    minimum: 7,
    maximum: 20,
    :message => "This is not a valid telephone number"
  }, if: :first_step?

  validates :company_phone_number, length: {
    minimum: 7,
    maximum: 20,
    message: "This is not a valid telephone number"
  }, allow_blank: true, if: :second_step?

  validates_with UserAccountValidator, on: :update, if: "account_id_changed?"

  begin :associations
    has_many :form_answers, dependent: :destroy
    has_one :owned_account, foreign_key: :owner_id, class_name: 'Account'

    belongs_to :account
    has_many :form_answer_attachments, as: :attachable
    has_many :support_letter_attachments, dependent: :destroy
    has_many :supporters, dependent: :destroy
  end

  begin :scopes
    scope :excluding, -> (user) {
      where.not(id: user.id)
    }
    scope :by_email, -> { order(:email) }

    # Scopes need to be changed once we have shortlisted/non shortlisted applications
    scope :shortlisted, -> { where("1 = 0") }
    scope :non_shortlisted, -> { where("1 = 0") }
  end

  before_create :create_account
  around_save :update_user_full_name

  enumerize :prefered_method_of_contact, in: %w(phone email)
  enumerize :qae_info_source, in: %w(govuk competitor business_event national_press business_press online local_trade_body national_trade_body mail_from_qae word_of_mouth other)
  enumerize :role, in: POSSIBLE_ROLES, predicates: true

  begin :searching
    pg_search_scope :basic_search,
                    against: [
                      :email,
                      :first_name,
                      :last_name,
                      :company_name
                    ],
                    using: {
                      tsearch: {
                        prefix: true
                      }
                    }
    # TODO: take into consideration forcing NULL for all attributes.
    nilify_blanks only: [
      :title,
      :first_name,
      :last_name,
      :company_name
    ]
  end

  def set_step (step)
    @current_step = step
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def reset_password_period_valid?
    release_date = Date.new(2015, 4, 21)
    if imported? && reset_password_sent_at.present? && reset_password_sent_at.to_date == release_date
      true
    else
      super
    end
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

  def update_user_full_name
    full_name_changed = first_name_changed? || last_name_changed?
    yield
    form_answers.each { |f| f.update_attributes(user_full_name: full_name) } if full_name_changed
  end
end
