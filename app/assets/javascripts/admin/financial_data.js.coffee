jQuery ->
  if ($ "#financial-summary form:not(#new_review_audit_certificate)").length
    form = ($ "#financial-summary form:not(#new_review_audit_certificate)")
    timer = null
    benchmarksTable = ($ "#financial-benchmarks")
    overallBenchmarksTable = ($ "#overall-financial-benchmarks")
    financialTable = ($ "#financial-table")

    $("input", form).on "change keyup keydown paste", ->
      timer ||= setTimeout(saveFinancials, 500)

    ($ "button", form).on "click", (event) ->
      do event.preventDefault
      $(this).closest(".form-group").removeClass("form-edit")

    updateExportsGrowth = (exports) ->
      exportsGrowth = ($ 'tr.exports-growth td.value', benchmarksTable)
      values = exports.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if values.length
        i = 0
        exportsGrowth.each (i, td) ->
          if i != 0 && values[i - 1] != NaN && values[i - 1] != 0
            growth = ( values[i] / values[i - 1] * 100 - 100).toFixed(2)
            ($ td).text(growth)

    updateExportsPercentage = (exports, turnover) ->
      exportsPercentage = ($ 'tr.exports-percentage td.value', benchmarksTable)
      exportsValues = exports.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())
      turnoverValues = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if exportsValues.length && turnoverValues.length
        exportsPercentage.each (i, td) ->
          if exportsValues[i] != NaN && turnoverValues[i] && turnoverValues[i] != NaN && exportsValues[i]
            growth = (exportsValues[i] / turnoverValues[i] * 100).toFixed(2)
            ($ td).text(growth)

    updateUKSales = (exports, turnover) ->
      uk_sales = ($ 'tr.uk-sales td.value', financialTable)
      exportsValues = exports.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())
      turnoverValues = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if exportsValues.length && turnoverValues.length
        uk_sales.each (i, td) ->
          if exportsValues[i] != NaN && turnoverValues[i] && turnoverValues[i] != NaN && exportsValues[i]
            sales = (turnoverValues[i] - exportsValues[i]).toFixed(2)
            ($ td).text(sales)

    updateOverallGrowth = (turnover) ->
      turnoverValues = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if i = turnoverValues.length
        growth = turnoverValues[i - 1] - turnoverValues[0]
        growthInPercents = (turnoverValues[i - 1] / turnoverValues[0] * 100 - 100).toFixed(2)

        ($ 'tr.overall-growth td.value', overallBenchmarksTable).text(growth)
        ($ 'tr.overall-growth-in-percents td.value', overallBenchmarksTable).text(growthInPercents)

    updateTurnoverGrowth = (turnover) ->
      turnoverValues = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      turnoverGrowth = ($ 'tr.turnover-growth td.value', benchmarksTable)

      if turnoverValues.length
        i = 0
        turnoverGrowth.each (i, td) ->
          if i != 0 && turnoverValues[i - 1] != NaN && turnoverValues[i - 1] != 0
            growth = ( turnoverValues[i] / turnoverValues[i - 1] * 100 - 100).toFixed(2)
            ($ td).text(growth)

    updateBenchmarks = ->
      exports = ($ 'tr.exports > td.value', financialTable)
      turnover = ($ 'tr.total_turnover > td.value', financialTable)

      updateExportsGrowth(exports)
      updateExportsPercentage(exports, turnover)
      updateOverallGrowth(turnover)
      updateTurnoverGrowth(turnover)
      updateUKSales(exports, turnover)

    saveFinancials = ->
      timer = null
      url = form.attr('action')
      formData = form.serialize()
      updateBenchmarks()
      $.ajax
        url: url
        data: formData
        type: 'POST'
        dataType: 'script'
        success: (_data) ->
          window.fire(form[0], 'ajax:x:success', null)

      ($ 'td.value', financialTable).each (i, td) ->
        input = ($ 'input', ($ td))
        ($ 'span', ($ td)).text(input.val())
