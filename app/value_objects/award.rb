class Award
  # This class used for handling saving / removing of Awards on EP form
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :title, :year, :details, :holder

  validates :title, :details, presence: true

  validates :title, length: { maximum: 100 }
  validates :year, length: { maximum: 4 },
                   presence: true, if: "self.holder?"

  # Should be 100 words maximum
  validates :details, length: {
    maximum: 100,
    tokenizer: -> (str) { str.split },
    message: "is too long (maximum is 100 words)"
  }

  def initialize(holder=false, attrs={})
    @holder = holder

    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end

  def holder?
    @holder
  end
end
