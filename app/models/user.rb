class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :agreed_with_privacy_policy

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create

  begin :associations
    has_many :form_answers, dependent: :destroy
  end

  private

  def password_required?
    new_record? ? super : false
  end
end
