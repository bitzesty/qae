/**
 * @license Copyright (c) CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.plugins.add("wordcount", {
    lang: "ar,ca,da,de,el,en,es,eu,fa,fi,fr,he,hr,hu,it,ja,nl,no,pl,pt,pt-br,ru,sk,sv,tr,zh-cn", // %REMOVE_LINE_CORE%
    version: 1.16,
    requires: 'htmlwriter,notification,undo',
    bbcodePluginLoaded: false,
    onLoad: function(editor) {
        CKEDITOR.document.appendStyleSheet(this.path + "css/wordcount.css");
    },
    init: function (editor) {
        var defaultFormat = "",
            intervalId,
            lastWordCount = -1,
            lastCharCount = -1,
            limitReachedNotified = false,
            limitRestoredNotified = false,
            snapShot = editor.getSnapshot(),
            notification = null;

        var maxWordCountWithBuffer = function(maxWordCount) {
          if (config.maxWordCount > 15) {
            return parseInt(config.maxWordCount * 1.1);
          } else {
            return config.maxWordCount;
          }
        };

        var dispatchEvent = function (type, currentLength, maxLength) {
            if (typeof document.dispatchEvent == 'undefined') {
                return;
            }

            type = 'ckeditor.wordcount.' + type;

            var cEvent;
            var eventInitDict = {
                bubbles: false,
                cancelable: true,
                detail: {
                    currentLength: currentLength,
                    maxLength: maxLength
                }
            };

            try {
                cEvent = new CustomEvent(type, eventInitDict);
            } catch (o_O) {
                cEvent = document.createEvent('CustomEvent');
                cEvent.initCustomEvent(
                    type,
                    eventInitDict.bubbles,
                    eventInitDict.cancelable,
                    eventInitDict.detail
                );
            }

            document.dispatchEvent(cEvent);
        };

        // Default Config
        var defaultConfig = {
            showParagraphs: false,
            showWordCount: true,
            showCharCount: false,
            countSpacesAsChars: false,
            countHTML: false,
            hardLimit: true,

            //MAXLENGTH Properties
            maxWordCount: -1,
            maxCharCount: -1,

            // Filter
            filter: null,

            // How long to show the 'paste' warning
            pasteWarningDuration: 0,

            //DisAllowed functions
            wordCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
                dispatchEvent('wordCountGreaterThanMaxLengthEvent', currentLength, maxLength);
            },
            charCountGreaterThanMaxLengthEvent: function (currentLength, maxLength) {
                dispatchEvent('charCountGreaterThanMaxLengthEvent', currentLength, maxLength);
            },

            //Allowed Functions
            wordCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
                dispatchEvent('wordCountLessThanMaxLengthEvent', currentLength, maxLength);
            },
            charCountLessThanMaxLengthEvent: function (currentLength, maxLength) {
                dispatchEvent('charCountLessThanMaxLengthEvent', currentLength, maxLength);
            }
        };

        // Get Config & Lang
        var config = CKEDITOR.tools.extend(defaultConfig, editor.config.wordcount || {}, true);

        if (config.showParagraphs) {
            defaultFormat += editor.lang.wordcount.Paragraphs + " %paragraphs%";
        }

        if (config.showParagraphs && (config.showWordCount || config.showCharCount)) {
            defaultFormat += ", ";
        }

        if (config.showWordCount) {
            defaultFormat += editor.lang.wordcount.WordCount + " %wordCount%";
            if (config.maxWordCount > -1) {
                defaultFormat += "/" + config.maxWordCount;
            }
        }

        if (config.showCharCount && config.showWordCount) {
            defaultFormat += ", ";
        }

        if (config.showCharCount) {
            var charLabel = editor.lang.wordcount[config.countHTML ? "CharCountWithHTML" : "CharCount"];

            defaultFormat += charLabel + " %charCount%";
            if (config.maxCharCount > -1) {
                defaultFormat += "/" + config.maxCharCount;
            }
        }

        var format = defaultFormat;

        bbcodePluginLoaded = typeof editor.plugins.bbcode != 'undefined';

       function counterId(editorInstance) {
            return "cke_wordcount_" + editorInstance.name;
        }

        function counterElement(editorInstance) {
            return document.getElementById(counterId(editorInstance));
        }

        function strip(html) {
            if (bbcodePluginLoaded) {
                // stripping out BBCode tags [...][/...]
                return html.replace(/\[.*?\]/gi, '');
            }

            var tmp = document.createElement("div");

            // Add filter before strip
            html = filter(html);

            tmp.innerHTML = html;

            if (tmp.textContent == "" && typeof tmp.innerText == "undefined") {
                return "";
            }

            return tmp.textContent || tmp.innerText;
        }

        /**
         * Implement filter to add or remove before counting
         * @param html
         * @returns string
         */
        function filter(html) {
            if(config.filter instanceof CKEDITOR.htmlParser.filter) {
                var fragment = CKEDITOR.htmlParser.fragment.fromHtml(html),
                    writer = new CKEDITOR.htmlParser.basicWriter();
                config.filter.applyTo( fragment );
                fragment.writeHtml( writer );
                return writer.getHtml();
            }
            return html;
        }

        function countCharacters(text, editorInstance) {
            if (config.countHTML) {
                return (filter(text).length);
            } else {
                var normalizedText;

                // strip body tags
                if (editor.config.fullPage) {
                    var i = text.search(new RegExp("<body>", "i"));
                    if (i != -1) {
                        var j = text.search(new RegExp("</body>", "i"));
                        text = text.substring(i + 6, j);
                    }

                }

                normalizedText = text;

                if (!config.countSpacesAsChars) {
                    normalizedText = text.
                        replace(/\s/g, "").
                        replace(/&nbsp;/g, "");
                }

                normalizedText = normalizedText.
                    replace(/(\r\n|\n|\r)/gm, "").
                    replace(/&nbsp;/gi, " ");

                normalizedText = strip(normalizedText).replace(/^([\t\r\n]*)$/, "");

                return(normalizedText.length);
            }
        }

        function countParagraphs(text) {
            return (text.replace(/&nbsp;/g, " ").replace(/(<([^>]+)>)/ig, "").replace(/^\s*$[\n\r]{1,}/gm, "++").split("++").length);
        }

        function countWords(text) {
            var normalizedText = text.
                replace(/(\r\n|\n|\r)/gm, " ").
                replace(/^\s+|\s+$/g, "").
                replace("&nbsp;", " ");

            normalizedText = strip(normalizedText);

            var words = normalizedText.split(/\s+/);

            for (var wordIndex = words.length - 1; wordIndex >= 0; wordIndex--) {
                if (words[wordIndex].match(/^([\s\t\r\n]*)$/)) {
                    words.splice(wordIndex, 1);
                }
            }

            return (words.length);
        }

        function limitReached(editorInstance, notify) {
            limitReachedNotified = true;
            limitRestoredNotified = false;

            if (config.hardLimit) {
                editorInstance.loadSnapshot(snapShot);
                // lock editor
                editorInstance.config.Locked = 1;
            }

            if (!notify) {
                counterElement(editorInstance).className = "cke_path_item cke_wordcountLimitReached";
                editorInstance.fire("limitReached", {}, editor);
            }
        }

        function limitRestored(editorInstance) {
            limitRestoredNotified = true;
            limitReachedNotified = false;
            editorInstance.config.Locked = 0;
            snapShot = editor.getSnapshot();

            counterElement(editorInstance).className = "cke_path_item";
        }

        function updateCounter(editorInstance) {
            var paragraphs = 0,
                wordCount = 0,
                charCount = 0,
                text;

            if (text = editorInstance.getData()) {
                if (config.showCharCount) {
                    charCount = countCharacters(text, editorInstance);
                }

                if (config.showParagraphs) {
                    paragraphs = countParagraphs(text);
                }

                if (config.showWordCount) {
                    wordCount = countWords(text);
                }
            }

            var html = format.replace("%wordCount%", wordCount).replace("%charCount%", charCount).replace("%paragraphs%", paragraphs);

            (editorInstance.config.wordcount || (editorInstance.config.wordcount = {})).wordCount = wordCount;
            (editorInstance.config.wordcount || (editorInstance.config.wordcount = {})).charCount = charCount;

            if (CKEDITOR.env.gecko) {
                counterElement(editorInstance).innerHTML = html;
            } else {
                counterElement(editorInstance).innerText = html;
            }

            if (charCount == lastCharCount && wordCount == lastWordCount) {
                return true;
            }

            return true;
        }

        editor.on("key", function (event) {
            if (editor.mode === "source") {
                updateCounter(event.editor);
            }
        }, editor, null, 100);

        editor.on("change", function (event) {
            updateCounter(event.editor);
        }, editor, null, 100);

        editor.on("uiSpace", function (event) {
            if (editor.elementMode === CKEDITOR.ELEMENT_MODE_INLINE) {
                if (event.data.space == "top") {
                    event.data.html += "<div class=\"cke_wordcount\" style=\"\"" +
                        " title=\"" +
                        editor.lang.wordcount.title +
                        "\"" +
                        "><span id=\"" +
                        counterId(event.editor) +
                        "\" class=\"cke_path_item\">&nbsp;</span></div>";
                }
            } else {
                if (event.data.space == "bottom") {
                    event.data.html += "<div class=\"cke_wordcount\" style=\"\"" +
                        " title=\"" +
                        editor.lang.wordcount.title +
                        "\"" +
                        "><span id=\"" +
                        counterId(event.editor) +
                        "\" class=\"cke_path_item\">&nbsp;</span></div>";
                }
            }

        }, editor, null, 100);

        editor.on("dataReady", function (event) {
            updateCounter(event.editor);
        }, editor, null, 100);

        editor.on("blur", function () {
            if (intervalId) {
                window.clearInterval(intervalId);
            }
        }, editor, null, 300);
    }
});
