filter_fares_by_location = (target) ->
  selected = $(target).val()

  if selected == 'from_oahu'
    $('.from_mainland').hide()
    $('.from_oahu').show()
  else if selected == 'from_mainland'
    $('.from_oahu').hide()
    $('.from_mainland').show()
  else
    $('.from_oahu').show()
    $('.from_mainland').show()

fetch_fare_details = (target) ->
  if $(target).find('img').length > 0
    $(target).html("<p>I have been replaced</p>")

toggle_chevron = (target) ->
  $(target).siblings().find('i').toggleClass('icon-chevron-down')
  $(target).siblings().find('i').toggleClass('icon-chevron-right')

jQuery ->
  # reset origin dropdown
  $('#origin_filter').val('all')

  $('.accordion-body').on 'show', -> 
    toggle_chevron(this)
    fetch_fare_details(this)

  $('.accordion-body').on 'hide', -> toggle_chevron(this)
  $('#origin_filter').change -> filter_fares_by_location(this)
  
