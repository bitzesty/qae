$(function(){
  $("textarea").bind('paste',function(e){
    var rte = $(this);
    setTimeout(function(){
        var text = rte.val();
        text = text.replace(/(.*(?:endif-->))|([ ]?<[^>]*>[ ]?)|(&nbsp;)|([^}]*})/g,'');
        text = text.replace(/¬/g,'');

        $(rte).val(text);
        $(rte).focus();
    },100);
});
});
