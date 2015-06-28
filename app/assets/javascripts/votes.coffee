ready = ->
  $(".vote").bind 'ajax:success', (e, data, status, xhr) ->
    controller_data = $.parseJSON(xhr.responseText)
    vote = controller_data.vote
    total_votes = controller_data.total_votes
    $("#" + vote.voteable_type.toLowerCase() + "_" + vote.voteable_id).find(".votes").html '<a class=\"vote-cancel\" data-type=\"json\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"\/' + vote.voteable_type.toLowerCase() + 's' + '\/' + vote.voteable_id + '\/cancel_vote\">Cancel<\/a>'
    $("#" + vote.voteable_type.toLowerCase() + "_" + vote.voteable_id).find(".total_votes").html total_votes

  $(".vote-cancel").bind 'ajax:success', (e, data, status, xhr) ->
    controller_data = $.parseJSON(xhr.responseText)
    vote = controller_data.vote
    total_votes = controller_data.total_votes
    $("#" + vote.voteable_type.toLowerCase() + "_" + vote.voteable_id).find(".votes").html '<a data-type=\"json\" class=\"vote\" data-remote=\"true\" rel=\"nofollow\" data-method=\"post\" href=\"\/' + vote.voteable_type.toLowerCase() + 's' + '\/' + vote.voteable_id + '\/like\">Like<\/a> <a data-type=\"json\" class=\"vote\" data-remote=\"true\" rel=\"nofollow\" data-method=\"post\" href=\"\/' + vote.voteable_type.toLowerCase() + 's' + '\/' + vote.voteable_id + '\/dislike\">Dislike<\/a>'
    $("#" + vote.voteable_type.toLowerCase() + "_" + vote.voteable_id).find(".total_votes").html total_votes

$(document).on('page:update', ready)