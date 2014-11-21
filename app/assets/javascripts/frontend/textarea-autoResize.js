// Resizable textareas based on http://www.impressivewebs.com/textarea-auto-resize/
/*global document:false, $:false */
var txt = $('textarea');
var hiddenDiv = $(document.createElement('div'));
var content = null;

txt.addClass('txtstuff');
hiddenDiv.addClass('hiddendiv common');
txt.each(function() {
  // default/initial heights for all textareas so
  // that resizing doesn't get shorter than this
  var textarea = $(this);
  textarea.css('min-height', textarea.outerHeight());
  textarea.attr("data-height", textarea.outerHeight())
});

$('body').append(hiddenDiv);

resizeTextarea = function (textInput) {
  content = textInput.val();

  content = content.replace(/\n/g, '<br>');
  hiddenDiv.html(content + '<br class="lbr">');

  if (hiddenDiv.height() >= textInput.attr("data-height")) {
    // resize when there's more text than the text container
    textInput.css("height", hiddenDiv.height()+1);
  } else if (content == "") {
    // resize when no text
    textInput.css("height", textInput.attr("data-height"));
  }
}

txt.each(function() {
  resizeTextarea($(this));
});

txt.on('keyup', function () {
  resizeTextarea($(this));
});

txt.on('mouseup', function () {
  // resize the text container with the textarea resize handle
  var textarea = $(this);
  textarea.css("height", textarea.height());
  textarea.attr("data-height", textarea.height())
});
