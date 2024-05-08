class CurrentQueensAward
  # This class used for handling saving / removing of Current King's Awards
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :categories, :years, :category, :year, :outcome, :outcomes

  validates :category, presence: { message: "Category is required and an option must be selected from the following list" }
  validates :year, presence: { message: "Year is required and an option must be selected from the following list" }
  validates :outcome, presence: { message: "Outcome is required and an option must be selected from the following list"}

  validates :category, length: { maximum: 100 },
    inclusion: {
      in: -> (record) { record.categories }
    }

  validates :year, length: { maximum: 4 },
    inclusion: {
      in: -> (record) { record.years }
    }

  def initialize(categories, years, outcomes, attrs={})
    @categories = categories.map { |c| [c.value] }.flatten.map(&:to_s)
    @years = years.map(&:to_s)
    @outcomes = outcomes.map { |o| [o.value, o.text] }

    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
