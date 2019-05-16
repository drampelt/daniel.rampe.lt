@n = "daniel"
@d = "rampe.lt"

$ ->
  new Typed '#typed',
    strings: ["a mobile developer", "a 22 year old guy", "a gamer", "a windsurfer"]
    typeSpeed: 40
    loop: true
    backDelay: 2000
    cursorChar: '&#x258c;'

  $('a').click (e) ->
    el = $ e.currentTarget
    if el.attr('href').charAt(0) is '#'
      e.preventDefault()
      target = $ el.attr 'href'
      $('body,html').animate scrollTop: target.position().top, 1000
