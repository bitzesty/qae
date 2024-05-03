class AssessorAssignmentCollection
  NOT_ASSIGNED = "not assigned"

  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :form_answer_ids, String
  attribute :primary_assessor_id, String
  attribute :secondary_assessor_id, String

  validate :assessors_can_not_be_the_same

  attr_reader :assignment_errors
  attr_accessor :subject

  def persisted?
    false
  end

  def save
    return unless valid?

    form_answers.each do |fa|
      next unless @subject.lead?(fa)

      prim = fa.assessor_assignments.primary
      sec = fa.assessor_assignments.secondary
      handle_double_assignment(fa, prim, sec)
      assign(fa, prim, sec)
    end
  end

  private

  def form_answers
    @form_answers ||= FormAnswer.where(id: ids).includes(:assessor_assignments)
  end

  def assign(fa, prim, sec)
    if primary_assignable?(fa)
      prim.assessor = primary_assessor
      prim.save || add_error(prim.errors.to_a)
    end

    return unless secondary_assignable?(fa)

    sec.assessor = secondary_assessor
    sec.save || add_error(sec.errors.to_a)
  end

  def handle_double_assignment(fa, prim, sec)
    if primary_assessor.present? &&
        secondary_assessor.present? &&
        primary_assignable?(fa) &&
        secondary_assignable?(fa) && (primary_assessor == sec.assessor ||
          secondary_assessor == prim.assessor)

      prim.assessor_id = nil
      sec.assessor_id = nil
      prim.save
      sec.save
    end
  end

  def add_error(error)
    @assignment_errors ||= []
    @assignment_errors << error
    @assignment_errors.flatten.uniq!
  end

  def ids
    form_answer_ids.split(",").select { |i| i =~ /\A\d+\z/ }
  end

  def primary_assignable?(fa)
    primary_assessor_id == NOT_ASSIGNED || primary_assessor.try(:assignable?, fa)
  end

  def secondary_assignable?(fa)
    secondary_assessor_id == NOT_ASSIGNED || secondary_assessor.try(:assignable?, fa)
  end

  def secondary_assessor
    return if secondary_assessor_id == NOT_ASSIGNED

    @secondary_assessor ||= Assessor.where(id: secondary_assessor_id).first
  end

  def primary_assessor
    return if primary_assessor_id == NOT_ASSIGNED

    @primary_assessor ||= Assessor.where(id: primary_assessor_id).first
  end

  def primary_assessor_present?
    primary_assessor_id.present? && primary_assessor_id != NOT_ASSIGNED
  end

  def assessors_can_not_be_the_same
    if primary_assessor_id == secondary_assessor_id &&
        primary_assessor_present?
      errors.add(:base, "Primary/Secondary Assessor can not be the same.")
    end
  end
end
