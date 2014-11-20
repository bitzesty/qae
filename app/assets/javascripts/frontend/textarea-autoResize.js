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
  textarea.css('min-height', textarea.height());
  textarea.attr("data-height", textarea.height())
});

$('body').append(hiddenDiv);

txt.on('keyup', function () {
  content = $(this).val();

  content = content.replace(/\n/g, '<br>');
  hiddenDiv.html(content + '<br class="lbr">');

  if (hiddenDiv.height() >= $(this).attr("data-height")) {
    // resize when there's more text than the text container
    $(this).css("height", hiddenDiv.height());
  } else if (content == "") {
    // resize when no text
    $(this).css("height", $(this).attr("data-height"));
  }
});

txt.on('mouseup', function () {
  // resize the text container with the textarea resize handle
  var textarea = $(this);
  textarea.css("height", textarea.height());
  textarea.attr("data-height", textarea.height())
});
