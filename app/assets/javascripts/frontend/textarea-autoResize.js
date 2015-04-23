// Resizable textareas based on http://www.impressivewebs.com/textarea-auto-resize/
/*global document:false, $:false */
$(function() {
  var txt = $('textarea');
  var content = null;

  resetResizeTextarea = function () {
    if (!$("body").hasClass("text-resized")) {
      $("textarea").each(function() {
        // default/initial heights for all textareas so
        // that resizing doesn't get shorter than this
        var textarea = $(this);
        textarea.css("height", "auto");
        textarea.css("min-height", "");
        textarea.removeAttr("min-height");
        textarea.css("min-height", textarea.attr("rows")*20+"px");
        textarea.attr("data-height", textarea.attr("rows")*20);
      });
      $("body").addClass("text-resized");
    }
  };

  resizeTextarea = function (textInput) {
    var content = textInput.val();
    var box_width = $(".step-article.step-current").width();
    var char_count = content.toString().length;
    var new_line_count = content.split("\n").length;
    var text_width = char_count * 8;
    var line_height = Math.ceil(text_width/box_width) + new_line_count;
    var newHeight = line_height*20;

    if (newHeight >= textInput.attr("data-height")) {
      // resize when there's more text than the text container
      textInput.height(newHeight);
    } else if (content === "") {
      // resize when no text
      textInput.height(textInput.attr("data-height"));
    }
  };

  resetResizeTextarea();

  txt.each(function() {
    resizeTextarea($(this));
  });

  txt.on("keyup paste", function (e) {
    if (e.keyCode != 9) {
      resizeTextarea($(this));
    }
  });

  txt.on("mouseup", function () {
    // resize the text container with the textarea resize handle
    var textarea = $(this);
    textarea.css("height", textarea.height());
  });
});
