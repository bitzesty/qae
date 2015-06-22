class Assessor < ActiveRecord::Base
  include PgSearch

  AVAILABLE_ROLES = ["lead", "regular"]
  # lead - created & assigned to Admin to specific categories
  # has access to almost all resources from all form answers within this category
  # regular - assigned by lead, as primary/secondary from set of all assessors assigned
  # to specific category (award type), they act per specific form answer.

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable

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

  scope :by_email, -> { order(:email) }

  def self.roles
    [["Not Assigned", nil], ["Lead Assessor", "lead"], ["Assessor", "regular"]]
  end

  def self.available_for(category)
    where(role_meth(category) => ["regular", "lead"])
  end

  def self.leads_for(category)
    where(role_meth(category) => "lead")
  end

  def self.role_meth(category)
    "#{category}_role"
  end

  def applications_scope
    c = assigned_categories_as(%w(lead))
    join = "LEFT OUTER JOIN assessor_assignments ON
    assessor_assignments.form_answer_id = form_answers.id"

    out = FormAnswer.joins(join)
    out.where("
      (award_type in (?) OR
      (assessor_assignments.position in (?) AND assessor_assignments.assessor_id = ?))
      AND state NOT IN (?)
    ", c, [0, 1], id, "withdrawn")
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def lead?(form_answer)
    get_role(form_answer.read_attribute(:award_type)) == "lead"
  end

  def regular?(form_answer)
    get_role(form_answer.read_attribute(:award_type)) == "regular"
  end

  def assignable?(form_answer)
    lead?(form_answer) || regular?(form_answer)
  end

  def lead_or_assigned?(form_answer)
    lead?(form_answer) || assigned?(form_answer)
  end

  def categories_as_lead
    categories.select { |_, v| v == "lead" }.keys
  end

  def assigned?(form_answer)
    form_answer.assessors.include?(self)
  end

  def primary?(form_answer)
    form_answer.assessor_assignments.primary.assessor_id == id
  end

  def secondary?(form_answer)
    form_answer.assessor_assignments.secondary.assessor_id == id
  end

  private

  def categories
    out = {}
    ["trade", "innovation", "development", "promotion"].each do |cat|
      out[cat] = public_send(self.class.role_meth(cat))
    end
    out
  end

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

  def self.leads_for(category)
    where(role_meth(category) => "lead")
  end
end
