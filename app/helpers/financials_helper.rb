module FinancialsHelper
  def formatted_uk_sales_value(field)
    val = (field.to_s.split(".").last == "0") ? field.to_f.round(0) : field
    number_with_delimiter(val)
  end
end
