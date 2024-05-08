class SimpleForm::AccountFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    super(attribute_name, options.merge(wrapper_html: { class: "question-group" }), &block)
  end
end
