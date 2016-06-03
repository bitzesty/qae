class Subsidiary
  # This class used for handling saving / removing of subsidiaries on Trade form
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :name, :location, :employees, :description

  validates :name, :location, :employees, presence: true,
                                          length: { maximum: 100 }

  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :description, presence: true, length: {
    maximum: 111,
    tokenizer: -> (str) { str.split },
    message: "is too long (maximum is 100 words)"
  }

  def initialize(attrs={})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
