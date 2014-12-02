class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :agreed_with_privacy_policy

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create

  begin :associations
    has_many :form_answers, dependent: :destroy
    has_one :eligibility, dependent: :destroy
  end

  enumerize :prefered_method_of_contact, in: %w(phone email)
  serialize :qae_info_source, Array
  enumerize :qae_info_source, in: %w(govuk compeditor business_event national_press business_press online local_trade_body national_trade_body mail_from_qae word_of_mouth other), multiple: false

  private

  def password_required?
    new_record? ? super : false
  end
end
