jQuery ->
  $('#folder_user_tokens').tokenInput('/users.json', {
    crossDomain: false
    preventDuplicates: true
    })
