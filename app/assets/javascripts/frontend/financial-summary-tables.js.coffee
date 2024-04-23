class FinancialSummaryTableTrade
  constructor: () ->
    @wrapper = $(".financial-summary-tables")
    @tableData = $(".user-financial-summary-table.trade-data")
    @tableGrowth = $(".user-financial-summary-table.trade-growth")
    @tableSummary = $(".user-financial-summary-table.trade-summary")

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
    numberOfYears = $(".fs-overseas-sales input:visible").length
    datePattern = /\d{2}\/\d{2}\/\d{4}/

    yearsLabels = $(".fs-overseas-sales .js-year-text:visible").map (i, el) =>
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
    @fillInRow("fs-overseas-sales")
    @fillInRow("fs-total-turnover")
    @fillInRow("fs-net-profit")

  renderTableGrowth: () =>
    salesGrowthRow = @tableGrowth.find("tr[data-type='fs-overseas-sales-growth']")

    # overseas sales growth
    salesOverseas = $(".fs-overseas-sales input:visible")
    salesOverseasValues = salesOverseas.map (i, input) ->
      parseFloat($(input).val())

    allOverseasSalesFilled = salesOverseas.toArray().every (input) ->
      $(input).val() != ""

    if !allOverseasSalesFilled
      @showFinancials = false
      salesGrowthRow.find("td:gt(0)").text("-")
    else
      salesOverseasValues.each (i, value) ->
        if i > 0
          previousValue = salesOverseasValues[i - 1]
          growth = ((value - previousValue) / previousValue) * 100
          salesGrowthRow.find("td:eq(#{i + 1})").text(growth.toFixed(0))
        else
         salesGrowthRow.find("td:eq(#{i + 1})").text("-")

    # overseas sales %
    salesPercentRow = @tableGrowth.find("tr[data-type='fs-overseas-sales-percentage']")
    turnover = $(".fs-total-turnover input:visible")
    turnoverValues = turnover.map (i, input) ->
      parseFloat($(input).val())

    allTotalTurnoverFilled = turnover.toArray().every (input) ->
      $(input).val() != ""

    if !allOverseasSalesFilled || !allTotalTurnoverFilled
      @showFinancials = false
      salesPercentRow.find("td:gt(0)").text("-")
    else
      salesOverseasValues.each (i, value) ->
        if turnoverValues[i] > 0
          value = (value / turnoverValues[i] * 100).toFixed(0)
        else
          value = "-"

        salesPercentRow.find("td:eq(#{i + 1})").text(value)

  renderTableSummary: () ->
    totalOverseasGrowth = @tableSummary.find("td[data-type='fs-overall-overseas-sales-growth']")
    totalOverseasGrowthPercentage = @tableSummary.find("td[data-type='fs-overall-overseas-sales-growth-percentage']")
    salesOverseas = $(".fs-overseas-sales input:visible")

    allOverseasSalesFilled = salesOverseas.toArray().every (input) ->
      $(input).val() != ""

    if !allOverseasSalesFilled
      @showFinancials = false
      totalOverseasGrowth.text("-")
      return

    overseasSalesValues = salesOverseas.map (i, input) ->
      parseFloat($(input).val())

    firstYear = overseasSalesValues[0]
    lastYear = overseasSalesValues[overseasSalesValues.length - 1]
    diff = lastYear - firstYear
    totalOverseasGrowth.text(diff)
    totalOverseasGrowthPercentage.text((diff / firstYear * 100).toFixed(0))


  fillInRow: (type) =>
    row = @tableData.find("tr[data-type='#{type}']")
    inputs = $(".#{type} input:visible")

    inputs.each (i, input) =>
      value = $(input).val()

      if value
        value = parseFloat(value).toLocaleString()
      else
        @showFinancials = false
        value = "-"

      console.log "#{@showFinancials} - #{value}"
      row.find("td:eq(#{i + 1})").text(value)

$(document).ready ->
  new FinancialSummaryTableTrade()
