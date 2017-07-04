CKEDITOR.editorConfig = function (config) {
  config.language = 'en';
  config.toolbar_mini = [
    {name: "clipboard", items: ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"]},
    {name: "basicstyles", items: ["Bold", "Italic",  "-", "RemoveFormat"]},
    {name: "paragraph", items: ["NumberedList", "BulletedList"]}
  ];
  config.toolbar = "mini";
  config.extraPlugins = 'wordcount';

  config.wordcount = {
    showParagraphs: false,
    showWordCount: true
  };

  config.removePlugins = 'elementspath';
}
