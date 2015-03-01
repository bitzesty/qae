class Assessor < ActiveRecord::Base
  include PgSearch

  AVAILABLE_ROLES = ["lead", "regular"]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, presence: true
  has_many :form_answer_attachments, as: :attachable

  before_validation :nil_if_blank

  validates :trade_role,
            :innovation_role,
            :development_role,
            :promotion_role,
            inclusion: {
              in: AVAILABLE_ROLES
            },
            allow_nil: true

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

  def self.roles_for_collection
    [["Lead Assessor", "lead"], ["Assessor", "regular"]]
  end

  private

  def nil_if_blank
    self.trade_role = nil if trade_role.blank?
    self.innovation_role = nil if innovation_role.blank?
    self.development_role = nil if development_role.blank?
    self.promotion_role = nil if promotion_role.blank?
  end
end
