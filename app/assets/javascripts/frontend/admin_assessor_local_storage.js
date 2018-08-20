// AALSLS => Admin Asessor Local Storage

if (AALS !== undefined) {
  window.alert("AALS is alreday defined");
}

var AALS = (function() {
  var init = function() {
    var scopeKey = $('body').data("user-scope-id");

    $('[data-behavior="autosave"]').keyup(function() {
      var autosaveKey = $(this).data("autosave-key");
      var key = scopeKey + "-" + autosaveKey;

      setItem(key, $(this).val());
    });

    $('[data-behavior="autosave"]').each(function() {
      var autosaveKey = $(this).data("autosave-key");
      var key = scopeKey + "-" + autosaveKey;

      var value = getItem(key);

      if(value) {
        $(this).val(value);
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

  var removeItem = function(key) {
    var scopeKey  = $('body').data("user-scope-id");
    key = scopeKey + "-" + key;

    return window.localStorage.removeItem(key);
  };

  var remainingSpace = function(){
    var _lsTotal = 0, _xLen, _x;
    var totalKB = 0;
    var totalMB = 0;

    for (_x in localStorage) {
      _xLen = (((localStorage[_x].length || 0) + (_x.length || 0)) * 2);
      _lsTotal += _xLen;
    }

    totalKB = (_lsTotal / 1024).toFixed(2);
    totalMB = (totalKB / 1024).toFixed(2);
  };

  return { "init": init, "removeItem": removeItem };
})();

$(document).ready(function() {
  if (typeof(Storage) !== "undefined") {
    if ($('[data-behavior="autosave"]').length) AALS.init();
  } else {
    console.log('Sorry! No Web Storage support');
  }
});
