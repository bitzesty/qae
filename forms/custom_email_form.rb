class CustomEmailForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend Enumerize

  SCOPES = %w[myself qae_opt_in_group bis_opt_in assessors all_users]

  attr_reader :scope, :message, :admin_id, :subject
  validates :message, :scope, :subject, presence: true

  enumerize :scope, in: SCOPES

  def initialize(attrs = {})
    @scope = attrs[:scope]
    @message = attrs[:message]
    @admin_id = attrs[:admin_id]
    @subject = attrs[:subject]
  end

  def persisted?
    false
  end

  def send!
    users.each do |user|
      Users::CustomMailer.notify(user.id, user.class.name, message, subject).deliver_later!
    rescue => e
      Rails.logger.debug "Error: #{e}"
      Appsignal.send_error(e)
    end
  end

  def users
    case scope
    when "myself"
      [Admin.find(admin_id)]
    when "qae_opt_in_group"
      User.confirmed.qae_opt_in_group.by_email
    when "bis_opt_in"
      User.confirmed.bit_opt_in.by_email
    when "assessors"
      Assessor.all.by_email
    when "all_users"
      User.confirmed.by_email
    else
      raise ArgumentError, "#{scope} is not included in the list"
    end
  end
end
