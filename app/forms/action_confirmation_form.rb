class ActionConfirmationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  KEYWORD = 'yes'

  attr_accessor :confirmation
  validates :confirmation, presence: true

  def attributes=(attrs = {})
    attrs.each do |attr, value|
      public_send("#{attr}=", value)
    end
  end

  def valid?
    super && confirmation == KEYWORD
  end

  def persisted?
    false
  end

  def notify!(mailer_class, users)
    users.each do |user|
      mailer_class.delay.notify(user)
    end

    true
  end
end
