class Award
  # This class used for handling saving / removing of Awards on EP form
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :question, :title, :year, :details, :holder

  validates :title, :details, presence: true

  validates :title, length: { maximum: 100 }
  validates :year, length: { maximum: 4 },
                   presence: true, if: -> { holder? }

  validates_with QuestionWordsValidator, field_name: :details

  def initialize(question, holder = false, attrs = {})
    @question = question
    @holder = holder

    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end

  def holder?
    @holder
  end
end
