window.TextareaWysywygSupport =
  init: ->

    CKEDITOR.basePath = "/ckeditor/"
    CKEDITOR.path = "/ckeditor/"

    if $('.js-ckeditor').length > 0

      $('.js-ckeditor').each (index) ->

        spacer = $("<div class='js-ckeditor-spacer'></div>")
        spacer.insertAfter($(this).parent().find(".hint"))

        CKEDITOR.replace this,
          toolbar: 'mini'
          height: 200

        CKEDITOR.on 'instanceCreated', (event) ->
          editor = event.editor
          element = editor.element

          editor.on 'configLoaded', ->
            editor.config.wordcount =
              maxWordCount: element.data('word-max'),
              showParagraphs: false,
              showWordCount: true

        CKEDITOR.on 'instanceReady', (event) ->
          target_id = event.editor.name

          spinner = $("#" + target_id).closest(".question-group").find(".js-ckeditor-spinner-block")
          spinner.addClass('hidden')

      for i of CKEDITOR.instances
        instance = CKEDITOR.instances[i]

        instance.on 'change', (event) ->
          target_id = event.editor.name
          element = CKEDITOR.instances[target_id]

          element.updateElement()
          window.changesUnsaved = true

          $("#" + target_id).trigger("change")

          return
