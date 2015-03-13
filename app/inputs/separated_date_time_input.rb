class SeparatedDateTimeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    out = ''.html_safe

    out << @builder.text_field("formatted_#{attribute_name}_date", input_html_options.merge(class: 'datepicker'))
    out << @builder.text_field("formatted_#{attribute_name}_time", input_html_options.merge(class: 'timepicker'))

    out
  end

  def label(wrapper_options)
    ""
  end
end
