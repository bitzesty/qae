class DeclarationOfResponsibilityForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES =
    [
      :impact_on_society,
      :impact_on_environment,
      :partners_relations,
      :employees_relations,
      :customers_relations
    ]

  attr_reader :form_answer

  attr_accessor *ATTRIBUTES

  ATTRIBUTES.each do |attr_name|
    class_eval <<-EVAL, __FILE__, __LINE__+1
      validate :words_in_#{attr_name}, if: Proc.new { |m| m.public_send("#{attr_name}").present? }
    EVAL
  end

  def initialize(form_answer)
    @form_answer = form_answer
    ATTRIBUTES.each do |attr_name|
      public_send("#{attr_name}=", form_answer.document[attr_name.to_s])
    end
  end

  def update(attrs = {})
    ATTRIBUTES.each do |attr_name|
      self.public_send("#{attr_name}=", attrs[attr_name])
    end

    return false unless valid?
    document = form_answer.document

    ATTRIBUTES.each do |attr_name|
      document[attr_name] = attrs[attr_name]
    end

    form_answer.document = document
    form_answer.save
  end

  def persisted?
    false
  end

  private

  ATTRIBUTES.each do |attr_name|
    define_method("words_in_#{attr_name}") do
      if public_send("#{attr_name}").split.size > 500
        errors.add(attr_name, "is too long (maximum is 500 words)")
      end
    end
  end
end
