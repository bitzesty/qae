class SeparatedDateTimeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    out = "".html_safe

    out << @builder.text_field("formatted_#{attribute_name}_date",
                               input_html_options.merge(class: "form-control datepicker",
                                                        placeholder: "dd/mm/yyyy",
                                                        aria: {label: "formatted_#{attribute_name}_date" }))
    out << @builder.text_field("formatted_#{attribute_name}_time",
                               input_html_options.merge(class: "form-control timepicker",
                                                        placeholder: "hh:mm",
                                                        aria: {label: "formatted_#{attribute_name}_time" }))

    out
  end

  def label(wrapper_options)
    ""
  end
end
