class Position
  # This class used for handling saving / removing of Position Details for EP form
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :name,
              :details,
              :ongoing,
              :start_month,
              :start_year,
              :end_month,
              :end_year

  validates :name,
            :start_month,
            :start_year, presence: true

  validates :name, length: { maximum: 500 }

  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :details, length: {
    maximum: 111,
    tokenizer: ->(str) { str.split },
    message: "is too long (maximum is 100 words)",
  }

  def initialize(attrs = {})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
