class window.FinancialSummaryTableBase
  constructor: () ->
    @wrapper = $(".financial-summary-tables")

    @tableData = $(".user-financial-summary-table.table-data")
    @tableGrowth = $(".user-financial-summary-table.table-growth")
    @tableSummary = $(".user-financial-summary-table.table-summary")

    setTimeout(@renderTables, 1000)

    $(".js-step-link").on "click", (e) =>
      setTimeout(@renderTables, 1000)

    $(".fs-trackable input").on "change", (e) =>
      setTimeout(@renderTables, 1000)

  renderTables: () =>
    return unless $(".fs-trackable:visible").length

    @showFinancials = true

    @adjustYears()
    @renderTableData()
    @renderTableGrowth()
    @renderTableSummary()

    if @showFinancials
      @wrapper.show()
      @wrapper.closest(".question-block").show()
    else
      @wrapper.hide()
      @wrapper.closest(".question-block").hide()

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

      row.find("td:eq(#{i + 1})").text(value)


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
          turnoverGrowthRow.find("td:eq(#{i + 1})").text(parseInt(growth).toLocaleString())
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
    totalTurnoverGrowth.text(diff.toLocaleString())
    totalTurnoverGrowthPercentage.text(parseInt(diff / firstYear * 100).toLocaleString())
