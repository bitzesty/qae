class ConfirmationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :params, :type, :confirmation

  validate :confirmed_or_rejected

  def initialize(type, params = {})
    @type = type
    @params = params
  end

  def confirmed?
    params[:confirmation] == "true"
  end

  private

  def confirmed_or_rejected
    return if params[:confirmation].in?(%w[true false])

    errors.add(:confirmation, I18n.t(type, scope: "confirmation_form.errors"))
  end
end
