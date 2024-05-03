class FormAnswer::DocumentParser
  # Used to convert JSON document to Hash
  # We use it in spec/factories/form_answer_factory.rb
  # and in Hstore to JSON db migration (MigrateFormAnswersDocumentToJson)
  def self.parse_json_document(doc)
    result = {}

    doc.each do |k, v|
      parsed_value = begin
        JSON.parse(v)
      rescue StandardError
        v
      end

      parsed_value = if parsed_value.is_a?(Array)
                       if parsed_value.any? { |el| el.include?("{") }
                         parsed_value.map { |el| JSON.parse(el) }
                       else # simple array, no need to parse it
                         parsed_value
                       end
                     elsif parsed_value.is_a?(Hash)
                       new_hash = {}

                       parsed_value.each do |key, value|
                         new_hash[key] = if value.is_a?(Hash)
                                           value
                                         else
                                           begin
                                             JSON.parse(value)
                                           rescue StandardError
                                             value
                                           end
                                         end
                       end

                       new_hash
                     else

                       parsed_value
                     end

      result[k] = parsed_value
    end

    result
  end
end
