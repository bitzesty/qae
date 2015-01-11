class Email
  include ActiveModel::Model

  attr_reader :email

  validates :email, presence: true, email: true

  def initialize(email)
    @email = email.to_s.strip
  end
end
