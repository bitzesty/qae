class Notifiers::WithdrawNotifier
  def initialize(fa)
    @fa = fa
  end

  def notify
    assessors = Assessor.leads_for(@fa.award_type)
    assessors.each do |assessor|
      Assessors::GeneralMailer.led_application_withdrawn(@fa.id, assessor.id).deliver_later!
    end
  end
end
