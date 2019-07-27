$(document).on('turbolinks:load', function(){
    $('.question-link').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })
});
 
