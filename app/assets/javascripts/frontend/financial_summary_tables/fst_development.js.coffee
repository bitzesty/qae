class FinancialSummaryTableDevelopment extends FinancialSummaryTableBase
  adjustYears: () =>
    datePattern = /\d{2}\/\d{2}\/\d{4}/

    yearsLabels = $(".fs-total-turnover .js-year-text:visible").map (i, el) =>
      if matched = $(el).text().match(datePattern)
        matched[0]
      else
        @showFinancials = false
        ""

    @morphTable(@tableData, yearsLabels)
    @morphTable(@tableGrowth, yearsLabels)

  morphTable: (table, yearsLabels) =>
    table.find("th").each (i, th) =>
      if i > 0
        $("span.year", th).text(yearsLabels[i - 1])

  renderTableData: () =>
    @fillInRow("fs-total-turnover")
    @fillInRow("fs-exports")
    @fillInRow("fs-uk-sales", true)
    @fillInRow("fs-net-profit")
    @fillInRow("fs-total-assets")

$(document).ready ->
  if $(".financial-summary-tables-development").length > 0
    new FinancialSummaryTableDevelopment()
