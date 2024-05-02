class FinancialSummaryTableInnovationUnit extends FinancialSummaryTableBase
  constructor: () ->
    @wrapper = $(".financial-summary-tables-two")

    @tableData = $(".user-financial-summary-table.table-two-data")

    setTimeout(@renderTables, 1000)

    $(".js-step-link").on "click", (e) =>
      setTimeout(@renderTables, 1000)

    $(".fs-two-trackable input").on "change", (e) =>
      setTimeout(@renderTables, 1000)

  adjustYears: () =>
    numberOfYears = $(".fs-total-turnover input:visible").length
    datePattern = /\d{2}\/\d{2}\/\d{4}/

    yearsLabels = $(".fs-total-turnover .js-year-text:visible").map (i, el) =>
      if matched = $(el).text().match(datePattern)
        matched[0]
      else
        @showFinancials = false
        ""

    @morphTable(@tableData, yearsLabels)

  morphTable: (table, yearsLabels) =>
    table.find("th").each (i, th) =>
      if i > 0
        $("span.year", th).text(yearsLabels[i - 1])

  renderTables: () =>
    return unless $(".fs-two-trackable:visible").length

    @showFinancials = true

    @adjustYears()
    @renderTableData()

    if @showFinancials
      @wrapper.show()
      @wrapper.closest(".question-block").show()
    else
      @wrapper.hide()
      @wrapper.closest(".question-block").hide()

  morphTable: (table, yearsLabels) =>
    table.find("th").each (i, th) =>
      if i > 0
        $("span.year", th).text(yearsLabels[i - 1])

  renderTableData: () =>
    @fillInRow("fs-two-units-sold")
    @fillInRow("fs-two-innovation-sales")
    @fillInRow("fs-two-exports")
    @fillInRow("fs-two-royalties")
    @fillInRow("fs-two-average-unit-price")
    @fillInRow("fs-two-direct-cost")

$(document).ready ->
  if $(".financial-summary-tables-innovation-two").length > 0
    new FinancialSummaryTableInnovationUnit()
