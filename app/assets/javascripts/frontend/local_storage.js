// LS => Local Storage

if (LS !== undefined) {
  window.alert("LS is alreday defined");
}

var LS = (function() {
  var init = function() {
    var autosaveToken = $('body').data("autosave-token");


    $('[data-behavior="autosave"]').keyup(function() {
      var autosaveKey = $(this).data("autosave-key");
      var key = autosaveToken + "-" + autosaveKey;

      setItem(key, $(this).val());

      if (remainingSpace() >= 4.8) {
        var html = "<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'><div class='modal-dialog'><div class='modal-content'><div class='modal-header'><h4>Warning!<h4></div><div class='modal-body'><p>Please save your current form!</p><br /><button type='button' class='btn btn-link' data-dismiss='modal'>Cancel</button></p></div></div></div></div>";
        $(html).modal('show');
      }
    });

    $('[data-behavior="autosave"]').each(function() {
      var autosaveKey = $(this).data("autosave-key");
      var key = autosaveToken + "-" + autosaveKey;

      var value = getItem(key);

      if(value) {
        $(this).val(value);
        $("[data-autosave-key='" + autosaveKey + "']").parents('.panel.panel-parent').css({border: "2px solid red"});
      }
    });
  };

  var setItem = function(key, value) {
    var storage = cryptio;

    storage.set(key, value, function(err, results){
      if(err) throw err;
    });
  };

  var getItem = function(key) {
    var storage = cryptio;

    var item;
    storage.get(key, function(err, results) {
      item = results;
    });

    return item;
  };

  var removeItem = function(autosaveKey) {
    var autosaveToken  = $('body').data("autosave-token");
    key = autosaveToken + "-" + autosaveKey;

    return window.localStorage.removeItem(key);
  };

  var remainingSpace = function(){
    var lsTotal = 0, i, iLength;
    var lsTotalInKB = 0;
    var lsTotalInMB = 0;

    for (i in localStorage) {
      iLength = (((localStorage[i].length || 0) + (i.length || 0)) * 2);
      lsTotal += iLength;
    }

    lsTotalInKB = (lsTotal / 1024).toFixed(2);
    lsTotalInMB = (lsTotalInKB / 1024).toFixed(2);
  };

  return { "init": init, "removeItem": removeItem };
})();

$(document).ready(function() {
  if (typeof(Storage) !== "undefined") {
    if ($('[data-behavior="autosave"]').length) LS.init();
  } else {
    console.log('Sorry! No Web Storage support');
  }
});
