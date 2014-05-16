//= require_tree .

# 宣告為全域物件
this.Draw = {}
Draw.rotate = 1
Draw.speed = 10 # 速度
$('.wheel').css
  '-moz-transition-duration': Draw.speed + 's'
  '-webkit-transition-duration': Draw.speed + 's'
  '-ms-transition-duration': Draw.speed + 's'
  'transition-duration': Draw.speed + 's'
$('.wheel .item').css
  '-moz-transition-duration': Draw.speed/2.4 + 's'
  '-webkit-transition-duration': Draw.speed/2.4 + 's'
  '-ms-transition-duration': Draw.speed/2.4 + 's'
  'transition-duration': Draw.speed/2.4 + 's'
$('.pointer').css
  '-moz-transition-duration': Draw.speed/2.4 + 's'
  '-webkit-transition-duration': Draw.speed/2.4 + 's'
  '-ms-transition-duration': Draw.speed/2.4 + 's'
  'transition-duration': Draw.speed/2.4 + 's'
$('.content').css
  '-moz-transition-duration': Draw.speed/2.4 + 's'
  '-webkit-transition-duration': Draw.speed/2.4 + 's'
  '-ms-transition-duration': Draw.speed/2.4 + 's'
  'transition-duration': Draw.speed/2.4 + 's'
Draw.winner = undefined
Draw.winnerIndex = null

data = demoData if !data

# Google 小姐語音
this.say = (Rlt, lng='zh-tw') ->
  lng = 'en' if Rlt.match('^[a-zA-Z\- ]*$')
  strURL = "http://translate.google.com.tw/translate_tts?q=" + Rlt + "&tl=" + lng
  embed = "<embed src=\"" + strURL + "\"/>"
  $('body').append('<div id="divSay" style="height: 0; overflow: hidden; position: absolute;"></div>') if $('#divSay').length == 0
  $('#divSay').html embed
  return

# 抓第一筆資料來解析
if data[0]['fullname']
  nameProperty = 'fullname'
else if data[0]['name']
  nameProperty = 'name'
else
  console.error "Error: Can't read name property form data"

FB = false

if data[0]['fbid']
  idProperty = 'fbid'
  FB = true
else if data[0]['id']
  idProperty = 'id'

avator = false

if data[0]['avator']
  avatorProperty = 'avator'
  avator = true
else if data[0]['img']
  avatorProperty = 'img'
  avator = true

Draw.drawing = false

refreshTickets = ->
  $('.ticket .name').each ->
    $(this).click ->
      say $(this).html()

Draw.draw = ->
  return if Draw.drawing
  Draw.drawing = true

  if Draw.winner
    $('.winners .ticket').css
      'height': 'initial',
      'margin-top': 'initial',
      'margin-left': 'initial',
      'opacity': 'initial',
    $('#item-0 .ticket').css
      'margin-left': '500px',
      'opacity': '0'
    setTimeout startDrawAnimate, 1000
    $('.pointer').removeClass 'show'
  else
    setTimeout startDrawAnimate, 100

  total = data.length
  Draw.winnerIndex = Math.floor((Math.random() * total))
  Draw.winner = data[Draw.winnerIndex]

  $('.winners').prepend generateHTML(Draw.winner, false)
  # $('.winner')[0].innerHTML = generateHTML(Draw.winner)
  refreshTickets()

startDrawAnimate = ->
  $('.wheel').css
    MozTransform: "rotateX(" + (720 * Draw.rotate) + "deg)"
    WebkitTransform: "rotateX(" + (720 * Draw.rotate) + "deg)"
    msTransform: "rotateX(" + (720 * Draw.rotate) + "deg)"
    transform: "rotateX(" + (720 * ++Draw.rotate) + "deg)"

  Draw.i = 0
  drawWheelUpdate()

  setTimeout afterDraw, Draw.speed*1000
  return Draw.winner

afterDraw = ->
  data.splice(Draw.winnerIndex, 1)
  Draw.drawing = false
  console.log('Draw done.')
  Draw.i = 0
  refreshTickets()
  afterDrawUpdate()

drawWheelUpdate = (isew=false) ->
  if Draw.i < 64
    total = data.length
    uIndex = Math.floor((Math.random() * total))
    $('.wheel .item')[31-(16+Draw.i)%32].innerHTML = generateHTML(data[uIndex])
    Draw.i++
    if isew
      if Draw.i < 32
        drawWheelUpdate(true)
    else
      setTimeout drawWheelUpdate, (Draw.speed*1000/64)*(Math.abs(Draw.i-31.5)*Math.abs(Draw.i-31.5)/2+2604.65625)/5209.3125
      if Draw.i == 1
        $('body').addClass('animateShow')
        rand = Math.floor((Math.random() * 4))
        $('body').addClass('a') if rand == 0
        $('body').addClass('b') if rand == 1
        $('body').addClass('c') if rand == 2
        $('body').addClass('d') if rand == 3
      else if Draw.i == 32
        $('body').removeClass('animateShow').removeClass('a').removeClass('b').removeClass('c').removeClass('d')
      else if Draw.i == 33
        $('.pointer').addClass 'show'
      if Draw.i == 48
        $('.wheel .item')[0].innerHTML = generateHTML(Draw.winner)

afterDrawUpdate = ->
  if Draw.i < 8
    if Draw.i%2 == 0
      $('.pointer').removeClass 'show'
    else
      $('.pointer').addClass 'show'
    Draw.i++
    setTimeout afterDrawUpdate, 320

generateHTML = (p, n=true) ->
  pNameHtml = '<div class="name">' + p[nameProperty] + '</div>'
  pIdHtml = '<div class="id">' + p[idProperty] + '</div>'
  pAvatorHtml = ''
  pAvatorHtml = '<a class="avator" target="_blank" href="https://facebook.com/' + p.fbid + '" style="background-image: url(http://graph.facebook.com/' + p.fbid + '/picture);"></a>' if FB
  pAvatorHtml = '<a class="avator" target="_blank" href="https://facebook.com/' + p.fbid + '" style="background-image: url(' + p[avatorProperty] + ');"></a>' if avator
  return '<div class="ticket">' + pAvatorHtml + pNameHtml + pIdHtml + '</div>' if n
  return '<div class="ticket" style="height: 0px; opacity: 0; margin-top: -50px; margin-left: 500px;">' + pAvatorHtml + pNameHtml + pIdHtml + '</div>'

# initialize
Draw.i = 0
drawWheelUpdate(true)

refreshView = ->
  # $('.wheel').css
  #   'margin-top': $(window).height()/2 + 'px',
  #   'margin-left': $(window).width()/2 + 'px'
refreshView()
$(window).resize ->
  refreshView()

# 鍵盤
document.body.onkeydown = (e) ->
  switch e.keyCode
    when 13
      Draw.draw()
    when 32
      Draw.draw()
