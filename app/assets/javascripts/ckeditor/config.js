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

  config.allowedContent = 'h1 h2 h3 p blockquote strong em i ul ol li;' +
                          'a[!href];' +
                          'img(left,right)[!src,alt,width,height];';
}
