class FinancialSummaryTableInnovation extends FinancialSummaryTableBase
  adjustYears: () =>
    numberOfYears = $(".fs-total-turnover input:visible").length
    datePattern = /\d{2}\/\d{2}\/\d{4}/

    yearsLabels = $(".fs-total-turnover .js-year-text:visible").map (i, el) =>
      if matched = $(el).text().match(datePattern)
        matched[0]
      else
        @showFinancials = false
        ""

    @morphTable(@tableData, numberOfYears, yearsLabels)
    @morphTable(@tableGrowth, numberOfYears, yearsLabels)

    @tableSummary.find("td.js-label-absolute-cell span").text("(year #{numberOfYears} minus 1)")
    @tableSummary.find("td.js-label-percent-cell span").text("(year #{numberOfYears} over year 1)")

  morphTable: (table, numberOfYears, yearsLabels) =>
    table.find("tr").each (i, row) =>
      $(row).find("td:gt(#{numberOfYears}), th:gt(#{numberOfYears})").hide()
      $(row).find("td:lt(#{numberOfYears + 1}), th:lt(#{numberOfYears + 1})").show()

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
  if $(".financial-summary-tables-innovation").length > 0
    new FinancialSummaryTableInnovation()
