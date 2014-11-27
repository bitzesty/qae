class FormAnswer < ActiveRecord::Base
  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :user, presence: true
  end

  store_accessor :settings
end
