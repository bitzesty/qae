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

  def self.roles
    [["Not Assigned", nil], ["Lead Assessor", "lead"], ["Assessor", "regular"]]
  end

  def applications_assigned_to_as(roles = ["regular", "lead"])
    FormAnswer.for_award_type(assigned_categories_as(roles))
  end

  private

  def get_role(name)
    public_send("#{name}_role")
  end

  def assigned_categories_as(roles)
    ["trade", "innovation", "development", "promotion"].map do |award|
      award if roles.include?(get_role(award).to_s)
    end.compact
  end

  def nil_if_blank
    self.trade_role = nil if get_role("trade").blank?
    self.innovation_role = nil if get_role("innovation").blank?
    self.development_role = nil if get_role("development").blank?
    self.promotion_role = nil if get_role("promotion").blank?
  end
end
