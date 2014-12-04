class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  belongs_to :owner, class_name: 'User', autosave: false, inverse_of: :owned_account
  validates :owner, presence: true
end
