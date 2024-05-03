class ApplicationPolicy
  attr_reader :subject, :record

  def initialize(subject, record)
    @subject = subject
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def admin?
    subject.is_a?(Admin)
  end

  def judge?
    subject.is_a?(Judge)
  end

  def assessor?
    subject.is_a?(Assessor)
  end

  def admin_or_lead_or_assigned?(fa)
    return true if subject.is_a?(Admin)

    assessor? &&
      subject.lead_or_assigned?(fa)
  end
end
