# LS => Local Storage

if window.LS != undefined
  window.alert 'LS is already defined'

window.LS = do ->
  init = ->
    autosaveToken = $('body').data('autosave-token')

    $('[data-behavior="autosave"]').keyup ->
      autosaveKey = $(this).data('autosave-key')
      key = autosaveToken + '-' + autosaveKey

      setItem key, $(this).val()

      if remainingSpace() >= 4.8 # LocalStorage size limit is 5 MB
        html = """
          <div class=\'modal fade\' tabindex=\'-1\' role=\'dialog\' aria-hidden=\'true\'>
            <div class=\'modal-dialog\'>
              <div class=\'modal-content\'>
                <div class=\'modal-header\'>
                  <h4>Warning!</h4>
                </div>
                <div class=\'modal-body\'>
                  <p>Please save your current form!</p>
                  <br/>
                  <button type=\'button\' class=\'btn btn-link\' data-dismiss=\'modal\'>Cancel</button>
                </div>
              </div>
            </div>
          </div>'
          """

        $(html).modal 'show'
      return

    $('[data-behavior="autosave"]').each ->
      autosaveKey = $(this).data('autosave-key')
      key = autosaveToken + '-' + autosaveKey

      value = getItem(key)

      if value
        $(this).val value
      return
    return

  setItem = (key, value) ->
    storage = cryptio
    storage.set key, value, (err, results) ->
      if err
        throw err
      return
    return

  getItem = (key) ->
    storage = cryptio
    item = undefined
    storage.get key, (err, results) ->
      item = results
      return
    item

  removeItem = (autosaveKey) ->
    return if typeof Storage == 'undefined'

    autosaveToken = $('body').data('autosave-token')
    key = autosaveToken + '-' + autosaveKey
    window.localStorage.removeItem key
    return

  remainingSpace = ->
    lsTotal = 0
    iLength = undefined
    lsTotalInKB = 0
    lsTotalInMB = 0

    for i of localStorage
      iLength = ((localStorage[i].length or 0) + (i.length or 0)) * 2
      lsTotal += iLength

    lsTotalInKB = (lsTotal / 1024).toFixed(2)
    lsTotalInMB = (lsTotalInKB / 1024).toFixed(2)
    return lsTotalInMB

  {
    'init': init
    'removeItem': removeItem,
    'remainingSpace': remainingSpace
  }

$(document).ready ->
  if typeof Storage != 'undefined'
    if $('[data-behavior="autosave"]').length
      LS.init()
  else
    console.log 'Sorry! No Web Storage support'
  return
