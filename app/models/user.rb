class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :agreed_with_privacy_policy

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create

  begin :associations
    has_many :form_answers, dependent: :destroy
  end

  enumerize :prefered_method_of_contact, in: %w(phone email)

  private

  def password_required?
    new_record? ? super : false
  end
end
