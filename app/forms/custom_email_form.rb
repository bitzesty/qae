class CustomEmailForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend Enumerize

  SCOPES = %w(myself qae_opt_in_group bis_opt_in assessors all_users)

  attr_reader :scope, :message, :user, :subject
  validates :message, :scope, :subject, presence: true

  enumerize :scope, in: SCOPES

  def initialize(attrs = {})
    @scope = attrs[:scope]
    @message = attrs[:message]
    @user = attrs[:user]
    @subject = attrs[:subject]
  end

  def persisted?
    false
  end

  def send!
    emails.each do |email|
      Users::CustomMailer.notify(email, message, subject).deliver_later!
    end
  end

  def emails
    case scope
    when "myself"
      [user.email]
    when "qae_opt_in_group"
      User.qae_opt_in_group.pluck(:email)
    when "bis_opt_in"
      User.bit_opt_in.pluck(:email)
    when "assessors"
      Assessor.all.pluck(:email)
    when "all_users"
      User.all.pluck(:email)
    else
      raise ArgumentError, "#{scope} is not included in the list"
    end
  end
end
