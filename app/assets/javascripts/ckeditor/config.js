CKEDITOR.editorConfig = function (config) {
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

  config.removePlugins = 'elementspath';
}
