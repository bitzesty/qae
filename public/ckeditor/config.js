CKEDITOR.editorConfig = function (config) {
  config.language = 'en';
  config.toolbar_mini = [
    {name: "clipboard", items: ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"]},
    {name: "tools", items: ["Maximize"]},
    {name: "basicstyles", items: ["Bold", "Italic",  "-", "RemoveFormat"]},
    {name: "paragraph", items: ["NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock"]}
  ];
  config.toolbar = "mini";
  config.extraPlugins = 'wordcount';
  config.wordcount = {
    showWordCount: true
  };
}
