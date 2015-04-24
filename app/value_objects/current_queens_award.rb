class CurrentQueensAward
  # This class used for handling saving / removing of Current Queens Awards
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :categories, :years, :category, :year

  validates :category, :year, presence: true

  validates :category, length: { maximum: 100 },
                       inclusion: {
                         in: -> (record) { record.categories }
                       }

  validates :year, length: { maximum: 4 },
                   inclusion: {
                     in: -> (record) { record.years }
                   }

  def initialize(categories, years, attrs={})
    @categories = categories.map { |c| [c.value] }.flatten.map(&:to_s)
    @years = years.map(&:to_s)

    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
