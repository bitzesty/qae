class FormLink
  # This class used for handling saving / removing of Form website links
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :link, :description

  validates :link, :description, presence: true
  validates :link, length: { maximum: 500 }

  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :description, length: {
    maximum: 111,
    tokenizer: -> (str) { str.split },
    message: "is too long (maximum is 100 words)",
  }

  def initialize(attrs={})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
