class QAEFormBuilder
  class BusinessSectorDropdownQuestionValidator < QuestionValidator
  end

  class BusinessSectorDropdownQuestionBuilder < DropdownQuestionBuilder
  end

  class BusinessSectorDropdownQuestion < DropdownQuestion
    SECTORS = [
      ["", "Select business sector"],
      ["agriculture_forestry_fishing", "Agriculture, Forestry, Fishing"],
      ["mining_and_quarrying", "Mining and Quarrying"],
      ["manufacture_food_products", "Manufacture > Food Products"],
      ["manufacture_beverages", "Manufacture > Beverages"],
      ["manufacture_textiles", "Manufacture > Textiles"],
      ["manufacture_leather", "Manufacture > Leather"],
      ["manufacture_wood", "Manufacture > Wood"],
      ["manufacture_paper", "Manufacture > Paper"],
      ["manufacture_coke / Petroleum", "Manufacture > Coke / Petroleum"],
      ["manufacture_chemicals", "Manufacture > Chemicals"],
      ["manufacture_rubber / Plastic", "Manufacture > Rubber / Plastic"],
      ["manufacture_other_non_metallic", "Manufacture > Other Non-Metallic"],
      ["manufacture_basic_metals", "Manufacture > Basic Metals"],
      ["manufacture_fabricated_metal", "Manufacture > Fabricated Metal"],
      ["manufacture_computer_electronic_optical", "Manufacture > Computer / Electronic / Optical"],
      ["manufacture_electrical_equipment", "Manufacture > Electrical Equipment"],
      ["manufacture_machinery_equipment", "Manufacture > Machinery Equipment"],
      ["manufacture_motor_vehicles", "Manufacture > Motor Vehicles"],
      ["manufacture_other_transport_equipment", "Manufacture > Other Transport Equipment"],
      ["manufacture_furniture", "Manufacture > Furniture"],
      ["printing_reproduction_recorded_media", "Printing / Reproduction / Recorded Media"],
      ["repair_installation_machinery_equipment", "Repair / Installation / Machinery Equipment"],
      ["electricity_gas_water_supply", "Electricity / Gas / Water Supply"],
      ["construction", "Construction"],
      ["wholesale_retail_trade", "Wholesale Retail Trade"],
      ["transportation_storage", "Transportation Storage"],
      ["cccommodation_food_service_activities", "Accommodation / Food Service Activities"],
      ["information_communication", "Information Communication"],
      ["financial_insurance_activities", "Financial Insurance Activities"],
      ["professional_scientific_technical", "Professional, Scientific, Technical"],
      ["administrative_support_service_activities", "Administrative Support Service Activities"],
      ["public_administration_defence", "Public Administration, Defence"],
      ["education", "Education"],
      ["human_health_social_work", "Human Health, Social Work"],
      ["arts_entertainment_recreation", "Arts, Entertainment, Recreation"],
      [:other, "Other"]
    ]

    def options
      return @options if @options.any?

      @options = SECTORS.map do |(value, text)|
        QuestionAnswerOption.new(value, text)
      end
    end
  end
end
