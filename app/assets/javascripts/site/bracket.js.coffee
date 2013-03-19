###
initialize '#bracket', ->
  bracket_data = $("#bracket_data").attr("data")
  bracket_data = JSON.parse(bracket_data)
  teams = bracket_data.table.teams
  console.log(teams) 
  canvas = this[0]
  context = canvas.getContext("2d")


### 
