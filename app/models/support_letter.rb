class SupportLetter < ActiveRecord::Base
  begin :associations
    belongs_to :supporter
    belongs_to :form_answer
    belongs_to :user

    has_one :support_letter_attachment
  end

  begin :validations
    validates :first_name,
              :last_name,
              :user,
              :form_answer,
              :relationship_to_nominee,
              :attachment, presence: true
  end

  attr_accessor :attachment
end
