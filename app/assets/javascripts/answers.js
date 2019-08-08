$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('.answers').on('ajax:success', '.rating', function(e) {
        var result = e.detail[0];
        $('#answer-' + result.answer.id + ' .score').text(result.answer.score);
    });
});
