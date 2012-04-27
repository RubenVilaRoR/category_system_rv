//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .
//= require bootstrap-alert

#// require bootstrap-transition
#// require bootstrap-button
#// require bootstrap-carousel
#// require bootstrap-collapse
//= require bootstrap-dropdown
#// require bootstrap-modal
#// require bootstrap-scrollspy
#// require bootstrap-tab
#// require bootstrap-tooltip
#// require bootstrap-popover
#// require bootstrap-typeahead

jQuery ->
  $('#notifications').delay(2500).slideUp('fast')
  $('#folder-list tbody').sortable
    axis: 'y'
    handle: '.icon-move '
    update: ->
      $.post($(this).data('url'), $(this).sortable('serialize'))