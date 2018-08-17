// AALSLS => Admin Asessor Local Storage

if (AALS !== undefined) {
  window.alert("AALS is alreday defined");
}

var AALS = (function() {
  var storage = cryptio;

  var init = function() {
    var scopeKey    = $('body').data("user-scope-id");

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
    storage.set(key, value, function(err, results){
      if(err) throw err;
    });
  };

  var getItem = function(key) {
    var item;
    storage.get(key, function(err, results) {
      item = results;
    });

    return item;
  };

  var removeItem = function(key) {
    return localStorage.removeItem(key);
  };

  return { "init": init };
})();

$(document).ready(function() {
  if (typeof(Storage) !== "undefined") {
    AALS.init();
  } else {
    console.log('Sorry! No Web Storage support');
  }
});


