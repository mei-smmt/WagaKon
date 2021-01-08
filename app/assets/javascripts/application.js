// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

/* global $*/
// 画像プレビュー表示
$( document ).on('turbolinks:load', function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
      }
     reader.readAsDataURL(input.files[0]);
    }
  }
  $("#book_img").change(function(){
    readURL(this);
  });
});

// レシピ材料の人数設定モーダル内エラーメッセージリセット
$( document ).on('turbolinks:load', function() {
  $('[data-dismiss="modal"]').click(function() {
    $('#size-validation-error').html("");
  });
});
