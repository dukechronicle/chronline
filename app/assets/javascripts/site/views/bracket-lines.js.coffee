SVG_NAMESPACE = 'http://www.w3.org/2000/svg'

teamHt = 22
teamSpc = 2
gameHt = 2 * teamHt + teamSpc
gameSpc = 14
roundWd = 31
round1Spc = 4
round2Spc = -14

window.BracketLinesView = Backbone.View.extend
  initialize: (options) ->
    @flipped = options['flipped']

  createLine: (x1, x2, y1, y2) ->
    if @flipped
      x1 = 100 - x1
      x2 = 100 - x2

    line = document.createElementNS(SVG_NAMESPACE, 'line')
    line.setAttribute('x1', "#{x1}%")
    line.setAttribute('x2', "#{x2}%")
    line.setAttribute('y1', y1)
    line.setAttribute('y2', y2)
    line.setAttribute('style', 'stroke:rgb(0,0,0);stroke-width:1')
    line

  drawLines: (x1, x2, y1, y2) ->
    @el.appendChild this.createLine(x1, x2, y1, y1)
    @el.appendChild this.createLine(x1, x2, y2, y2)
    @el.appendChild this.createLine(x2, x2, y1, y2)

  render: ->
    svg = document.createElementNS(SVG_NAMESPACE, 'svg')
    svg.setAttribute('class', 'bracket-lines')
    svg.setAttribute('width', '100%')
    svg.setAttribute('height', 8 * gameHt + 7 * gameSpc)
    this.setElement(svg)

    for i in [0...4]
      this.drawLines(
        roundWd,
        50,
        (gameHt / 2) + 2 * i * (gameHt + gameSpc),
        (gameHt / 2) + (2 * i + 1) * (gameHt + gameSpc)
      )

    for i in [0...2]
      this.drawLines(
        2 * roundWd + round1Spc,
        75,
        (gameHt + gameSpc / 2) + 2 * i * 2 * (gameHt + gameSpc),
        (gameHt + gameSpc / 2) + (2 * i + 1) * 2 * (gameHt + gameSpc)
      )

    this.drawLines(
      3 * roundWd + round1Spc + round2Spc,
      90,
      2 * gameHt + 3 * gameSpc / 2,
      6 * gameHt + 11 * gameSpc / 2
    )

    this
