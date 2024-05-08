class Judge < ApplicationRecord
  include PgSearch::Model

  AVAILABLE_ROLES = ["judge"]

  devise :database_authenticatable,
    :recoverable, :trackable, :validatable, :confirmable,
    :zxcvbnable, :lockable, :timeoutable, :session_limitable
  include PasswordValidator

  validates :first_name, :last_name, presence: true

  validates :trade_role,
    :innovation_role,
    :development_role,
    :mobility_role,
    :promotion_role,
    inclusion: {
      in: AVAILABLE_ROLES,
    },
    allow_blank: true

  pg_search_scope :basic_search,
    against: [
      :first_name,
      :last_name,
      :email,
    ],
    using: {
      tsearch: {
        prefix: true,
      },
    }

  scope :active, -> { where(deleted: false) }

  def active_for_authentication?
    super && !deleted?
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def self.role_meth(category)
    "#{category}_role"
  end

  def self.roles
    [["Not Assigned", nil], ["Assigned", "judge"]]
  end

  def assigned_award_types
    FormAnswer::POSSIBLE_AWARDS.select do |category|
      public_send("#{category}_role").present?
    end
  end

  def timeout_in
    30.minutes
  end

  def soft_delete!
    update_column(:deleted, true)
  end

  def roles
    FormAnswer::POSSIBLE_AWARDS.select do |cat|
      get_role(cat) == "judge"
    end
  end

  private

  def get_role(category)
    public_send self.class.role_meth(category)
  end
end
