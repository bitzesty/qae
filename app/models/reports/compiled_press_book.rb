require "rubyXL"
require "rubyXL/convenience_methods/cell"
require "rubyXL/convenience_methods/color"
require "rubyXL/convenience_methods/font"
require "rubyXL/convenience_methods/workbook"
require "rubyXL/convenience_methods/worksheet"

class Reports::CompiledPressBook
  attr_reader :groupped_form_answers, :scope

  DARK_BG = "0C2050"
  LIGHT_BG = "2E497A"
  WHITE_FONT = "FFFFFF"
  COLORED_FONT = "2E497A"

  HEADER_FONT_SIZE = 11
  FONT_SIZE = 11

  class PressBookFormAnswer
    include Reports::DataPickers::FormDocumentPicker

    attr_reader :obj, :financial_data
    def initialize(obj)
      @obj = obj
      @financial_data = obj.financial_data || {}
    end

    delegate :company_or_nominee_name, :mobility?, :trade?, :development?, :innovation?, to: :obj

    def principal_address
      [
        doc("organization_address_building"),
        doc("organization_address_street"),
        doc("organization_address_city"),
        principal_county,
        doc("organization_address_postcode"),
      ].map(&:presence).compact.join(", ")
    end

    def press_contact_full_name
      if obj.press_summary.try(:name).present? && obj.press_summary.last_name.present?
        [
          obj.press_summary.title,
          obj.press_summary.name,
          obj.press_summary.last_name,
        ]
      else
        [
          obj.document["press_contact_details_title"],
          obj.document["press_contact_details_first_name"],
          obj.document["press_contact_details_last_name"],
        ]
      end.map(&:presence).compact.join(" ")
    end

    def press_contact_tel
      obj.press_summary.try(:phone_number) || obj.document["press_contact_details_telephone"]
    end

    def press_contact_email
      obj.press_summary.try(:email) || obj.document["press_contact_details_email"]
    end

    def press_contact_notes
      obj.press_summary.try(:body)
    end

    private

    def business_form?
      true
    end

    def principal_county
      doc("organization_address_county").to_s.split(" - ").first.to_s
    end

    def doc(key)
      obj.document[key]
    end
  end

  ATTRIBUTES_MAP = {
    company_or_nominee_name: "Company Name",
    principal_address: "Address",
    unit_website: "Website",
    employees: "Employees",
    immediate_parent_name: "Immediate Parent",
    head_full_name: "Chief Executive",
    press_contact_full_name: "Press Contact",
    press_contact_tel: "Tel",
    press_contact_email: "Email",
    press_contact_notes: "Press Book Notes",
  }

  def initialize(year)
    @scope = year.form_answers
              .where(state: "awarded")
              .includes(:user, :palace_invite)
              .order(Arel.sql("form_answers.document->>'organization_address_region', company_or_nominee_name"))

    @groupped_form_answers = group_form_answers(scope)
  end

  def build
    workbook = RubyXL::Workbook.new

    render_stats(workbook)

    groupped_form_answers.each do |region, form_answers|
      render_region(workbook, region, form_answers)
    end

    workbook
  end

  def render_region(workbook, region, form_answers)
    worksheet = workbook.add_worksheet(region)

    main_header = "Region: #{region}"
    header_cell = worksheet.add_cell(1, 0, main_header)
    worksheet.merge_cells(1, 0, 1, 1)

    header_cell.change_font_color(WHITE_FONT)
    header_cell.change_font_size(HEADER_FONT_SIZE)
    header_cell.change_font_bold(true)
    header_cell.change_vertical_alignment("center")

    worksheet.change_column_width(0, 20)
    worksheet.change_column_width(1, 60)

    worksheet.sheet_data[1][0].change_fill(DARK_BG)

    current_row_index = 3

    current_row_index = render_category(:innovation, worksheet, current_row_index, form_answers)
    current_row_index = render_category(:trade, worksheet, current_row_index, form_answers)
    current_row_index = render_category(:mobility, worksheet, current_row_index, form_answers)
    render_category(:development, worksheet, current_row_index, form_answers)
  end

  def render_category(category, worksheet, current_row_index, form_answers = [])
    category_form_answers = form_answers.select(&:"#{category}?")

    return current_row_index if category_form_answers.none?

    # Category header
    header = "Category: #{FormAnswer::AWARD_TYPE_FULL_NAMES[category.to_s]}"

    header_cell = worksheet.add_cell(current_row_index, 0, header)

    worksheet.merge_cells(current_row_index, 0, current_row_index, 1)
    worksheet.sheet_data[current_row_index][0].change_fill(DARK_BG)
    header_cell.change_font_color(WHITE_FONT)
    header_cell.change_font_size(HEADER_FONT_SIZE)
    header_cell.change_font_bold(true)
    header_cell.change_vertical_alignment("center")

    # / Category header

    current_row_index += 2

    category_form_answers.compact.each do |form_answer|
      ATTRIBUTES_MAP.each do |method_name, pretty_name|
        attr_name_cell = worksheet.add_cell(current_row_index, 0, pretty_name)
        attr_name_cell.change_font_color(WHITE_FONT)
        attr_name_cell.change_fill(LIGHT_BG)
        attr_name_cell.change_font_size(FONT_SIZE)
        attr_name_cell.change_font_bold(true)
        attr_name_cell.change_vertical_alignment("top")

        attr_cell = worksheet.add_cell(current_row_index, 1, PressBookFormAnswer.new(form_answer).public_send(method_name))
        attr_cell.change_font_size(FONT_SIZE)
        attr_cell.change_text_wrap(true)
        attr_cell.change_vertical_alignment("top")

        if method_name == :company_or_nominee_name
          attr_cell.change_font_bold(true)
          attr_cell.change_font_color(COLORED_FONT)
        end

        current_row_index += 1
      end

      current_row_index += 1
    end

    current_row_index
  end

  def render_stats(workbook)
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = "Stats"

    main_header = "Number of recipients by region and award category"

    table_headers = [
      "Region",
      "Innovation",
      "International Trade",
      "Promoting Opportunity",
      "Sustainable Development",
      "Total",
    ]

    header_cell = worksheet.add_cell(0, 0, main_header)
    worksheet.merge_cells(0, 0, 0, 5)
    worksheet.sheet_data[0][0].change_fill(DARK_BG)

    header_cell.change_font_color(WHITE_FONT)
    header_cell.change_font_size(HEADER_FONT_SIZE)
    header_cell.change_font_bold(true)
    header_cell.change_vertical_alignment("center")

    # changing columns width
    worksheet.change_column_width(0, 30)
    5.times { |i| worksheet.change_column_width(i + 1, 15) }

    table_headers.each_with_index do |header, index|
      cell = worksheet.add_cell(2, index, header)

      cell.change_fill(LIGHT_BG)
      cell.change_font_color(WHITE_FONT)
      cell.change_text_wrap(true)
      cell.change_font_size(FONT_SIZE)
      cell.change_vertical_alignment("top")
    end

    worksheet.sheet_data[2][0].change_font_bold(true)

    current_row_index = 3

    groupped_form_answers.each do |region, fa|
      # Adding region
      region_cell = worksheet.add_cell(current_row_index, 0, region)
      region_cell.change_font_color(COLORED_FONT)
      region_cell.change_font_bold(true)
      region_cell.change_font_size(FONT_SIZE)

      worksheet.add_cell(current_row_index, 1, fa.count(&:innovation?)).change_font_size(FONT_SIZE)
      worksheet.add_cell(current_row_index, 2, fa.count(&:trade?)).change_font_size(FONT_SIZE)
      worksheet.add_cell(current_row_index, 3, fa.count(&:mobility?)).change_font_size(FONT_SIZE)
      worksheet.add_cell(current_row_index, 4, fa.count(&:development?)).change_font_size(FONT_SIZE)
      total_region_cell = worksheet.add_cell(current_row_index, 5, fa.count)
      total_region_cell.change_font_bold(true)
      total_region_cell.change_font_size(FONT_SIZE)

      current_row_index += 1
    end

    total_cell = worksheet.add_cell(current_row_index, 0, "Total")
    total_cell.change_font_color(COLORED_FONT)
    total_cell.change_font_bold(true)
    total_cell.change_font_size(FONT_SIZE)

    totals = %w[innovation trade mobility development total]

    5.times do |i|
      render_total_cell(worksheet, current_row_index, i + 1, totals[i])
    end
  end

  private

  def render_total_cell(worksheet, row_i, column_i, category)
    total_count = if category == "total"
      scope.count
    else
      scope.where(award_type: category).count
    end

    cell = worksheet.add_cell(row_i, column_i, total_count)
    cell.change_font_bold(true)
    cell.change_font_size(FONT_SIZE)
  end

  def group_form_answers(form_answers)
    groupped = form_answers.group_by do |fa|
      fa.document["organization_address_region"]
    end
  end
end
