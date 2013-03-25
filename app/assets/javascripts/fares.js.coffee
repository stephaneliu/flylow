jQuery ->
  $('#origin_filter').val('all')

  $('.accordion-body').on 'show', ->
    $(this).siblings().find('i').addClass('icon-chevron-down')
    $(this).siblings().find('i').removeClass('icon-chevron-right')
  $('.accordion-body').on 'hide', ->
    $(this).siblings().find('i').removeClass('icon-chevron-down')
    $(this).siblings().find('i').addClass('icon-chevron-right')

  $('#origin_filter').change ->
    selected = $(this).val()

    if selected == 'from_oahu'
      $('.from_mainland').hide()
      $('.from_oahu').show()
    else if selected == 'from_mainland'
      $('.from_oahu').hide()
      $('.from_mainland').show()
    else
      $('.from_oahu').show()
      $('.from_mainland').show()

