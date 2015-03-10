class Assessor < ActiveRecord::Base
  include PgSearch

  AVAILABLE_ROLES = ["lead", "regular"]
  # lead - created & assigned to Admin to specific categories
  # has access to almost all resources from all form answers within this category
  # regular - assigned by lead, as primary/secondary from set of all assessors assigned
  # to specific category (award type), they act per specific form answer.

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, presence: true
  has_many :form_answer_attachments, as: :attachable
  has_many :assessor_assignments

  has_many :form_answers,
           through: :assessor_assignments

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

  def self.available_for(category)
    where(role_meth(category) => ["regular", "lead"])
  end

  def applications_assigned_to_as(roles = ["regular", "lead"])
    FormAnswer.for_award_type(assigned_categories_as(roles))
  end

  def self.role_meth(category)
    "#{category}_role"
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def lead?(form_answer)
    get_role(form_answer.read_attribute(:award_type)) == "lead"
  end

  def primary?(form_answer)
    form_answer.assessor_assignments.primary.assessor == self
  end

  def secondary?(form_answer)
    form_answer.assessor_assignments.secondary.assessor == self
  end

  private

  def get_role(category)
    public_send self.class.role_meth(category)
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
