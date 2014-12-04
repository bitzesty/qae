class FormAnswer < ActiveRecord::Base
  begin :associations
    belongs_to :user
    belongs_to :account
  end

  begin :validations
    validates :user, presence: true
  end

  store_accessor :settings

  before_create :set_account

  private

  def set_account
    self.account = user.account
  end
end
