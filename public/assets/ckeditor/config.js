CKEDITOR.editorConfig = function (config) {
  config.language = 'en';
  config.toolbar_mini = [
    {name: "clipboard", items: ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"]},
    {name: "basicstyles", items: ["Bold", "Italic",  "-", "RemoveFormat"]},
    {name: "paragraph", items: ["NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock"]}
  ];
  config.toolbar = "mini";
  config.extraPlugins = 'wordcount';

  config.wordcount = {
    showParagraphs: false,
    showWordCount: true
  };

  config.removePlugins = 'elementspath,contextmenu,liststyle,tabletools,tableselection';
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
;
