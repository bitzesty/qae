$ = jQuery

$.fn.extend
  timePicker: (options) ->
    settings =
      values: [
        '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00',
        '03:30', '04:00', '04:30', '05:00', '05:30', '06:00', '06:30',
        '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00',
        '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
        '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00',
        '17:30', '18:00', '18:30', '19:00', '19:30', '20:00', '20:30',
        '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
      ]

    settings = $.extend settings, options

    _setValue = (input, option, wrapper) ->
      input = ($ input)
      input.val ($ option).text()
      input.trigger 'change'
      do input.focus
      do wrapper.hide

    _extractMinutes = (value) ->
      hours = parseInt(value.split(':')[0])
      minutes = parseInt(value.split(':')[1])

      if (hours == 0 || hours) && (minutes == 0 || minutes) # rejects undefined, NaN, null, etc.
        hours * 60 + minutes

    _timeToString = (minutes) ->
      hoursString = Math.floor(minutes/60)
      hoursString = '0' + hoursString if hoursString < 10
      minutesString = minutes % 60
      minutesString = '0' + minutesString if minutesString < 10

      "#{hoursString}:#{minutesString}"

    _timePicker = (element, settings) ->
      wrapper = ($ '<div class="time-picker"></div>')
      wrapperOver = false
      optionsList = ($ '<ul></ul>')

      for time in settings.values
        optionsList.append("<li>#{time}</li>")

      valuesInMinutes = []
      for time in settings.values
        valuesInMinutes.push _extractMinutes(time)

      wrapper.append optionsList
      wrapper.appendTo('body').hide()

      ($ "li", optionsList).mouseover( ->
        ($ this).addClass "selected"
      ).mouseout( ->
        ($ this).removeClass "selected"
      ).click( ->
        ($ this).closest("ul").find(".active").removeClass("active")
        ($ this).addClass "active"
        _setValue(element, this, wrapper)
      )

      wrapper.mouseover(->
        wrapperOver = true
      ).mouseout(->
        wrapperOver = false
      )

      showPicker = ->
        if wrapper.is(":visible")
          return false

        ($ 'li', wrapper).removeClass('selected')

        elementOffset = ($ element).offset()
        wrapper.css(top: elementOffset.top + element.offsetHeight, left: elementOffset.left)

        time = if element.value then _extractMinutes(element.value) else 0

        closest = null

        for d in valuesInMinutes
          if time < d
            closest = d
            break

        closestMin = valuesInMinutes[valuesInMinutes.indexOf(closest) - 1]

        do wrapper.show

        closestOption = ($ "li:contains(#{_timeToString(closestMin)})", wrapper)
        if closestMin && closestOption.length
          closestOption.addClass "active"
          wrapper[0].scrollTop = closestOption[0].offsetTop

      ($ element).focus(showPicker).click(showPicker)

      ($ element).blur ->
        if !wrapperOver
          do wrapper.hide

    @each ->
      _timePicker(this, settings)
