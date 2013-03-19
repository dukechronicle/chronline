class Page::Layouts::Bracket < Layout
  def schema
   {

    'teams' => {
      'label' => 'Teams',
      'type' => 'object',
      'properties' => {
        'midwest' => {
          'label' => 'Midwest',
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'school' => { 
                'label' => 'school',
                'type' => 'string',
                'required' => true
              },
              'image'  => { 
                'label' => 'image',
                'type' => 'string', 
                'required' => true
              }
            }
          }
        },
        'west' => {
          'label' => 'West',
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'school' => { 
                'label' => 'school',
                'type' => 'string',
                'required' => true
              },
              'image'  => { 
                'label' => 'image',
                'type' => 'string', 
                'required' => true
              }
            }
          }
        },
        'south' => {
          'label' => 'South',
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'school' => { 
                'label' => 'school',
                'type' => 'string',
                'required' => true
              },
              'image'  => { 
                'label' => 'image',
                'type' => 'string', 
                'required' => true
              }
            }
          }
        },
        'east' => {
          'label' => 'East',
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'school' => { 
                'label' => 'school',
                'type' => 'string',
                'required' => true
              },
              'image'  => { 
                'label' => 'image',
                'type' => 'string', 
                'required' => true
              }
            }
          }
        }

      }
    },
    'standings' => {
      'label' => 'Rounds Standings',
      'type' => 'array',
      'items' => {
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'team1'  => { 
              'label' => 'team1',
              'type' => 'number',
              'required' => true
            },
            'team2'  => { 
              'label' => 'team2',
              'type' => 'number', 
              'required' => true
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
        }
      }
    }
  }   
  end

end
