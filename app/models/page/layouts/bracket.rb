class Page::Layouts::Bracket < Layout
  def schema
   {
    'description' => 'Bracket Schema',
    'type' => 'object',
    'properties' => {
      'teams' => {
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'school' => { 'type' => 'string' },
            'image'  => { 'type' => 'string' },
            'seed'   => { 'type' => 'number' }
          },
          'required' => ['school', 'image', 'seed']
        }
      },
      'standings' => {
        'type' => 'array',
        'items' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'team1'  => { 'type' => 'number' },
              'team2'  => { 'type' => 'number' },
              'score1' => { 'type' => 'number' },
              'score2' => { 'type' => 'number' }
            },
            'required' => ['team1', 'team2']
          }
        }
      }
    }
  }   
  end

end
