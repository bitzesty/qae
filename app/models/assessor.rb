class Assessor < ActiveRecord::Base
  include PgSearch

  AVAILABLE_ROLES = ["lead", "regular"]
  # lead - created & assigned to Admin to specific categories
  # has access to almost all resources from all form answers within this category
  # regular - assigned by lead, as primary/secondary from set of all assessors assigned
  # to specific category (award type), they act per specific form answer.

  devise :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable #, :timeoutable

  validates :first_name, :last_name, presence: true
  has_many :form_answer_attachments, as: :attachable
  has_many :assessor_assignments

  has_many :form_answers,
           through: :assessor_assignments

  before_validation :nil_if_blank

  validates :trade_role,
            :innovation_role,
            :development_role,
            :mobility_role,
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

  default_scope { where(deleted: false) }

  scope :by_email, -> { order(:email) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  FormAnswer::POSSIBLE_AWARDS.each do |award_category|
    AVAILABLE_ROLES.each do |role|
      scope "#{award_category}_#{role}", -> {
        where("#{award_category}_role" => role)
      }
    end
  end

  def active_for_authentication?
    super && !deleted?
  end

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

  def applications_scope(award_year = nil)
    c = assigned_categories_as(%w(lead))
    join = "LEFT OUTER JOIN assessor_assignments ON
    assessor_assignments.form_answer_id = form_answers.id"

    scope = if award_year
      award_year.form_answers
    else
      FormAnswer
    end

    out = scope.joins(join)
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

  def lead_for_any_category?
    FormAnswer::POSSIBLE_AWARDS.any? do |cat|
      get_role(cat) == "lead"
    end
  end

  def lead_roles
    FormAnswer::POSSIBLE_AWARDS.select do |cat|
      get_role(cat) == "lead"
    end
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

  def soft_delete!
    update_column(:deleted, true)
  end

  def timeout_in
    30.minutes
  end

  private

  def categories
    out = {}

    FormAnswer::POSSIBLE_AWARDS.each do |cat|
      out[cat] = public_send(self.class.role_meth(cat))
    end
    out
  end

  def get_role(category)
    public_send self.class.role_meth(category)
  end

  def assigned_categories_as(roles)
    FormAnswer::POSSIBLE_AWARDS.map do |award|
      award if roles.include?(get_role(award).to_s)
    end.compact
  end

  def nil_if_blank
    FormAnswer::POSSIBLE_AWARDS.each do |award|
      self.public_send("#{award}_role=", nil) if get_role(award).blank?
    end
  end

  def self.leads_for(category)
    where(role_meth(category) => "lead")
  end
end
