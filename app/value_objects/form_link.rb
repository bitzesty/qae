class FormLink
  include ActiveModel::Model

  attr_reader :link, :description

  validates :link, :description, presence: true
  validates :link, length: { maximum: 500 }
  validates :description, length: { maximum: 5000 }

  def initialize(attrs={})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
