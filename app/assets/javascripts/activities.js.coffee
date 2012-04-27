jQuery ->
  $('#advance-search').live 'click', ->
    $('#advance-search-form').toggle()
    $('#simple-search-form').toggle()