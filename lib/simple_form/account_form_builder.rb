class SimpleForm::AccountFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &)
    super(attribute_name, options.merge(wrapper_html: { class: "question-group" }), &)
  end
end
