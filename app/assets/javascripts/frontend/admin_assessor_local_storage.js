// AALSLS => Admin Asessor Local Storage

if (AALS !== undefined) {
  window.alert("AALS is alreday defined");
}

var AALS = (function() {
  var setItem = function(key, value) {
    return localStorage.setItem(key, value);
  };

  var getItem = function(key) {
    return localStorage.getItem(key);
  };

  var removeItem = function(key) {
    return localStorage.removeItem(key);
  };

  return { "setItem": setItem, "getItem": getItem };
})();

$(document).ready(function() {
  if (typeof(Storage) == "undefined") {
    console.log('Sorry! No Web Storage support');
  }

  $('#assessor_assignment_corporate_social_responsibility_desc').keypress(function(){
    AALS.setItem('assessor_assignment_corporate_social_responsibility_desc', $('#assessor_assignment_corporate_social_responsibility_desc').val());
  });

  if (AALS.getItem('assessor_assignment_corporate_social_responsibility_desc')) {
    $('#assessor_assignment_corporate_social_responsibility_desc').val(AALS.getItem('assessor_assignment_corporate_social_responsibility_desc'));
  }
});


