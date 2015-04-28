module NonJsFormHelper
  def detect_index_of_dynamic_list_element
    element = existing_list_doc.detect do |el|
      detect_condition(el)
    end

    res.index(element)
  end
end
