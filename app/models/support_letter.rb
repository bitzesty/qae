class SupportLetter < ActiveRecord::Base
  belongs_to :supporter

  validates :supporter, :body, presence: true
end
