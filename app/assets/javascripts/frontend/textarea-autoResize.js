// Resizable textareas based on http://www.impressivewebs.com/textarea-auto-resize/
/*global document:false, $:false */
$(function() {
  var txt = $('textarea');
  var content = null;

  resetResizeTextarea = function () {
    if (!$("body").hasClass("text-resized")) {
      $('textarea').each(function() {
        // default/initial heights for all textareas so
        // that resizing doesn't get shorter than this
        var textarea = $(this);
        textarea.css('height', "auto");
        textarea.css('min-height', "");
        textarea.removeAttr('min-height');
        textarea.css('min-height', textarea.attr("rows")+"em");
        textarea.attr("data-height", parseInt(textarea.css('min-height')));
      });
      $("body").addClass("text-resized");
    }
  }

  resizeTextarea = function (textInput) {
    var hiddenDiv = $('body > .hiddendiv');
    content = textInput.val();

    content = content.replace(/\n/g, '<br>');
    hiddenDiv.width($(".step-article.step-current").width());
    hiddenDiv.html(content + '<br class="lbr">');
    var hiddenHeight = hiddenDiv.height()*1.06;

    if (hiddenHeight >= textInput.attr("data-height")) {
      // resize when there's more text than the text container
      textInput.height(hiddenHeight+1);
    } else if (content == "") {
      // resize when no text
      textInput.height(textInput.attr("data-height"));
    }
  }

  resetResizeTextarea()
  $('body').append("<div class='hiddendiv common'></div>");

  txt.each(function() {
    resizeTextarea($(this));
  });

  txt.on('keyup', function (e) {
    if (e.keyCode != 9) {
      resizeTextarea($(this));
    }
  });

  txt.on('mouseup', function () {
    // resize the text container with the textarea resize handle
    var textarea = $(this);
    textarea.css("height", textarea.height());
    textarea.attr("data-height", textarea.height())
  });
});
