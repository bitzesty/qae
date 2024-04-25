class FinancialSummaryTableInnovation
  constructor: () ->
    @wrapper = $(".financial-summary-tables")
    @tableData = $(".user-financial-summary-table.innovation-data")
    @tableGrowth = $(".user-financial-summary-table.innovation-growth")
    @tableSummary = $(".user-financial-summary-table.innovation-summary")
    console.log "init"
    setTimeout(@renderTables, 1000)

    $(".fs-trackable input").on "change", (e) =>
      setTimeout(@renderTables, 1000)

  renderTables: () =>
    console.log("rendering tables")
    @showFinancials = true

    @adjustYears()
    @renderTableData()
    @renderTableGrowth()
    @renderTableSummary()
    console.log @showFinancials
    if @showFinancials
      console.log("showing")
      @wrapper.show()
    else
      console.log("hiding")
      @wrapper.hide()

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

  renderTableGrowth: () =>
    turnoverGrowthRow = @tableGrowth.find("tr[data-type='fs-turnover-growth']")

    # overseas sales growth
    turnover = $(".fs-total-turnover input:visible")
    turnoverValues = turnover.map (i, input) ->
      parseFloat($(input).val())

    allTurnoverFilled = turnover.toArray().every (input) ->
      $(input).val() != ""

    if !allTurnoverFilled
      @showFinancials = false
      turnoverGrowthRow.find("td:gt(0)").text("-")
    else
      turnoverValues.each (i, value) ->
        if i > 0
          previousValue = turnoverValues[i - 1]
          growth = ((value - previousValue) / previousValue) * 100
          turnoverGrowthRow.find("td:eq(#{i + 1})").text(growth.toFixed(0))
        else
          turnoverGrowthRow.find("td:eq(#{i + 1})").text("-")

  renderTableSummary: () ->
    totalTurnoverGrowth = @tableSummary.find("td[data-type='fs-overall-turnover-growth']")
    totalTurnoverGrowthPercentage = @tableSummary.find("td[data-type='fs-overall-turnover-growth-percentage']")
    turnover = $(".fs-total-turnover input:visible")

    allTurnoverFilled = turnover.toArray().every (input) ->
      $(input).val() != ""

    if !allTurnoverFilled
      @showFinancials = false
      totalTurnoverGrowth.text("-")
      return

    turnoverValues = turnover.map (i, input) ->
      parseFloat($(input).val())

    firstYear = turnoverValues[0]
    lastYear = turnoverValues[turnoverValues.length - 1]
    diff = lastYear - firstYear
    totalTurnoverGrowth.text(diff)
    totalTurnoverGrowthPercentage.text((diff / firstYear * 100).toFixed(0))


  fillInRow: (type, calculatable = false) =>
    row = @tableData.find("tr[data-type='#{type}']")

    elements =
      if calculatable
        $(".#{type} span.fs-calculated:visible")
      else
        $(".#{type} input:visible")

    elements.each (i, el) =>
      value = if calculatable
        $(el).text()
      else
        $(el).val()

      if value
        value = parseFloat(value).toLocaleString()
      else
        @showFinancials = false
        value = "-"

      console.log "#{@showFinancials} - #{value}"
      row.find("td:eq(#{i + 1})").text(value)

$(document).ready ->
  if $(".financial-summary-tables-innovation").length > 0
    new FinancialSummaryTableInnovation()
