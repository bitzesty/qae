 (function($) {
  function debounce(callback, delay) {
    var self = this, timeout, _arguments;
    return function() {
      _arguments = Array.prototype.slice.call(arguments, 0),
      timeout = clearTimeout(timeout, _arguments),
      timeout = setTimeout(function() {
        callback.apply(self, _arguments);
        timeout = 0;
      }, delay);

      return this;
    };
  }

  $.extend($.fn, {
    debounce: function(event, selector, callback, delay, immediateCallback) {
      // where we use only three params
      if (delay === undefined) {
        this.bind(event, debounce.apply(this, [selector, callback]));
      } else {
        newFunc = debounce.apply(this, [callback, delay])
        this.on(event, selector, function() {
          if (immediateCallback !== undefined) {
            immediateCallback();
          }

          newFunc.call(arguments)
        });
      }
    }
  });
})(jQuery);
