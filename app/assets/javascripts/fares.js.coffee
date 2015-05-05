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
    fare_id = $(target).data('id')
    $.get(Routes.fare_details_path(fare_id), {target: $(target).attr('id')}, null, "script")

toggle_chevron = (target) ->
  $(target).siblings().find('span').toggleClass('rotated')

jQuery ->
  # reset origin dropdown
  $('#origin_filter').val('all')
  $('#origin_filter').change -> filter_fares_by_location(this)

  $('.panel-collapse').on 'show.bs.collapse', -> 
    toggle_chevron(this)
    fetch_fare_details(this)

  $('.panel-collapse').on 'hide.bs.collapse', -> toggle_chevron(this)
  
