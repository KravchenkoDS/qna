$(document).on('turbolinks:load', function(){
    $('.question-link').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    });
    $('.question .rating').on('ajax:success', function(e) {
        var result = e.detail[0];
        console.log(result.question.score)
        $('.question .score').text(result.question.score)
    })
});
