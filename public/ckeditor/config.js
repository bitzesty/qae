CKEDITOR.editorConfig = function (config) {
  config.language = 'en';
  config.toolbar_mini = [
    ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"],
    ["Bold", "Italic",  "-", "RemoveFormat"],
    ["NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock"]
  ];
  config.toolbar = "mini";
  config.extraPlugins = 'wordcount';

  config.wordcount = {
    showParagraphs: false,
    showWordCount: true
  };

  config.removePlugins = 'link,elementspath,contextmenu,liststyle,tabletools,tableselection';
  config.disableNativeSpellChecker = false;

  config.allowedContent = {
    'h1 h2 h3 blockquote p ul ol li a em i strong text br': true,
    'h1 h2 h3 blockquote p ul ol li a em i strong': {
      styles: 'text-align'
    },
    a: {
      attributes: '!href'
    },
  }
}
