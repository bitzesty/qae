class SupportLetter < ActiveRecord::Base
  begin :associations
    belongs_to :supporter
    has_many :support_letter_attachments, dependent: :destroy
  end

  begin :validations
    validates :supporter, :body, presence: true
  end
end
