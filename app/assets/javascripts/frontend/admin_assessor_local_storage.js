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
      remainingSpace();
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
    var allStrings = '';

    for(var key in window.localStorage){
      if(window.localStorage.hasOwnProperty(key)){
        allStrings += window.localStorage[key];
      }
    }
    currentSpace = allStrings ? 3 + ((allStrings.length*16)/(8*1024)) : 0;

    if (4850 < currentSpace) {
      alert("Please save your data! Memory is limited for autosave!");
    }
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
