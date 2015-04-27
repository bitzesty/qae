class Subsidiary
  # This class used for handling saving / removing of subsidiaries on Trade form
  # when JS is disabled

  include ActiveModel::Model

  attr_reader :name, :location, :employees

  validates :name, :location, :employees, length: { maximum: 100 }

  def initialize(attrs={})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
