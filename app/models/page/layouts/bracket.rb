class Page::Layouts::Bracket < Layout
  def schema
   {
    'teams' => {
      'label' => 'Teams',
      'type' => 'array',
      'items' => {
        'type' => 'object',
        'properties' => {
          'school' => { 
            'label' => 'school',
            'type' => 'string' 
          },
          'image'  => { 
            'label' => 'image',
            'type' => 'string' 
          },
          'seed'   => { 
            'label' => 'seed',
            'type' => 'number' 
          }
      },
      'required' => ['school', 'image', 'seed']
      }
    },
    'standings' => {
      'label' => 'Rounds Standings',
      'type' => 'array',
      'items' => {
        'label' => 'Round',
        'type' => 'array',
        'items' => {
          'label' => 'Match',
          'type' => 'object',
          'properties' => {
            'team1'  => { 
              'label' => 'team1',
              'type' => 'number' 
            },
            'team2'  => { 
              'label' => 'team2',
              'type' => 'number' 
            },
            'score1' => { 
              'label' => 'score1',
              'type' => 'number' 
            },
            'score2' => { 
              'label' => 'score2',
              'type' => 'number' 
            }
          },
          'required' => ['team1', 'team2']
        }
      }
    }
  }   
  end

end
