class SupportLetter < ApplicationRecord
  begin :associations
    belongs_to :supporter, optional: true
    belongs_to :form_answer, optional: true
    belongs_to :user, optional: true

    has_one :support_letter_attachment, autosave: true, dependent: :destroy
  end

  begin :validations
    validates :first_name,
              :last_name,
              :user,
              :form_answer,
              :relationship_to_nominee, presence: true
    validates :attachment, presence: true, if: proc { manual? && !support_letter_attachment }
    validates :body, presence: true, unless: :manual?
    validates :support_letter_attachment, presence: true, if: proc { manual? }
  end

  begin :scopes
    scope :manual, -> { where(manual: true) }
    scope :not_manual, -> { where(manual: false) }
  end

  attr_accessor :attachment

  def full_name
    [first_name, last_name].join(" ")
  end
end
