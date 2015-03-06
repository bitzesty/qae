jQuery ->
  if ($ "#financial-summary form").length
    form = ($ "#financial-summary form")
    timer = null
    benchmarksTable = ($ "#financial-benchmarks")
    overallBenchmarksTable = ($ "#overall-financial-benchmarks")
    financialTable = ($ "#financial-table")

    ($ "input", form).on "change keyup keydown paste", ->
      timer ||= setTimeout(saveFinancials, 500 )

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
            growth = Math.round( values[i] / values[i - 1] * 100 - 100)
            ($ td).text(growth)

    updateExportsPercentage = (exports, turnover) ->
      exportsPercentage = ($ 'tr.exports-percentage td.value', benchmarksTable)
      exports_values = exports.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())
      turnover_values = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if exports_values.length && turnover_values.length
        exportsPercentage.each (i, td) ->
          if exports_values[i] != NaN && turnover_values[i] != 0 && turnover_values[i] != NaN && exports_values[i] != 0
            growth = Math.round(exports_values[i] / turnover_values[i] * 100)
            ($ td).text(growth)

    updateOverallGrowth = (turnover) ->
      turnover_values = turnover.map (i, td) ->
        parseInt(($ 'input', ($ td)).val())

      if i = turnover_values.length
        growth = turnover_values[i - 1] - turnover_values[0]
        growthInPercents = Math.round(turnover_values[i - 1] / turnover_values[0] * 100 - 100)

        ($ 'tr.overall-growth td.value', overallBenchmarksTable).text(growth)
        ($ 'tr.overall-growth-in-percents td.value', overallBenchmarksTable).text(growthInPercents)

    updateBenchmarks = ->
      exports = ($ 'tr.exports > td.value', financialTable)
      turnover = ($ 'tr.total_turnover > td.value', financialTable)

      updateExportsGrowth(exports)
      updateExportsPercentage(exports, turnover)
      updateOverallGrowth(turnover)

    saveFinancials = ->
      timer = null
      url = form.attr('action')
      form_data = form.serialize()
      updateBenchmarks()

      jqXHR = $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'js'
      })

      ($ 'td.value', financialTable).each (i, td) ->
        input = ($ 'input', ($ td))
        ($ 'span', ($ td)).text(input.val())
