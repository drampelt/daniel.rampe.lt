$ ->
  $('#typed').typed
    strings: ["a student", "an 18 year old guy", "a technology fan", "a gamer", "a windsurfer"]
    typeSpeed: 0
    loop: true
    backDelay: 2000

  $('a').click (e) ->
    el = $ e.currentTarget
    if el.attr('href').charAt(0) is '#'
      e.preventDefault()
      target = $ el.attr 'href'
      $('body,html').animate scrollTop: target.position().top, 1000
