class Admin < ApplicationRecord
  include PgSearch::Model
  include AutosaveTokenGeneration

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :authy_authenticatable, :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable, :timeoutable, :session_limitable
  include PasswordValidator

  validates :first_name, :last_name, presence: true

  has_many :form_answer_attachments, as: :attachable

  default_scope { where(deleted: false) }

  pg_search_scope :basic_search,
                  against: [
                    :first_name,
                    :last_name,
                    :email
                  ],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }
  def lead?(*)
    true
  end

  def primary?(*)
    true
  end

  def secondary?(*)
    true
  end

  def lead_or_assigned?(*)
    true
  end

  def active_for_authentication?
    super && !deleted?
  end

  def soft_delete!
    update_column(:deleted, true)
  end

  def timeout_in
    30.minutes
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  private

  def min_password_score
    3
  end
end
