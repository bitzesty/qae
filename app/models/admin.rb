class Admin < ActiveRecord::Base
  include PgSearch

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :authy_authenticatable, :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable, :timeoutable

  validates :first_name, :last_name, presence: true

  has_many :form_answer_attachments, as: :attachable

  default_scope { where(deleted: false) }

  before_create :set_autosave_token

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

  private

  def min_password_score
    3
  end

  def set_autosave_token
    self.autosave_token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)
      break token unless User.where(autosave_token: token).exists?
    end
  end
end
