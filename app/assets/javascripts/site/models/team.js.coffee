window.Team = Backbone.Model.extend
  image: (size) ->
    "//a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/#{this.get('espn_id')}.png?w=#{size}&h=#{size}&transparent=true"
