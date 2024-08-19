$(function(){
  $('textarea').bind('paste',function(e){
    var rte = $(this);
    setTimeout(function(){
      var text = rte.val();
      text = text.replace(/\<head[^>]*\>([^]*)\<\/head/gi, '');
      text = text.replace(/\<script[^>]*\>([^]*)\<\/script/gi, '');
      text = text.replace(/\<style[^>]*\>([^]*)\<\/style/gi, '');
      text = text.replace(/(.*(?:endif-->))|([ ]?<[^>]*>[ ]?)|(&nbsp;)|([^}]*})/g, '');
      text = text.replace(/¬/g, '');

      $(rte).val(text);
      $(rte).focus();
    },100);
  });
});
