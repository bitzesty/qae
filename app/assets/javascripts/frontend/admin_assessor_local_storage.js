// AALSLS => Admin Asessor Local Storage

if (AALS !== undefined) {
  window.alert("AALS is alreday defined");
}

var AALS = (function() {

  var init = function() {
    $('[data-behavior="autosave"]').keypress(function(){
      var key = $(this).data("autosave-key");
      setItem(key, $(this).val());
    });

    $('[data-behavior="autosave"]').each(function(){
      var key = $(this).data("autosave-key");
      var value = getItem(key);
      if(value) {
        $(this).val(value);
      }
    });
  };

  var setItem = function(key, value) {
    return localStorage.setItem(key, value);
  };

  var getItem = function(key) {
    return localStorage.getItem(key);
  };

  var removeItem = function(key) {
    return localStorage.removeItem(key);
  };

  return { "init": init, "setItem": setItem, "getItem": getItem };
})();

$(document).ready(function() {
  if (typeof(Storage) !== "undefined") {
    AALS.init();
  } else {
    console.log('Sorry! No Web Storage support');
  }
});


