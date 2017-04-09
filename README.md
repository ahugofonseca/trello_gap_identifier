# Configure gem to run locally #

## Setup ##

Clone repository and run:
```
$ bundle install
$ gem build trello_gap_identifier.gemspec
$ gem install ./trello_gap_identifier-0.0.1.gem
```


## Usage ##
```
$ pry
```

```ruby
require 'gap_identifier'

# Set Trello API config:

GapIdentifier.configure do |config|
  config.member_token = '324ef5fda6ca2711e3c06354804e'
  config.developer_public_key = '26d9fb5cf4bd86fc67569c'
  config.board_id = 4
  config.username = 'hudsonsferreira'
end

GapIdentifier.cards_exceed_list_average_time
```

Output:
```ruby
[
  {
    id: '5824862bd3665336ad7e61f0',
    card: 'Ajustes',
    lists: [
      {
        list_id: '580f51ba372779f74d8f840a',
        list: 'Desenvolvendo',
        list_average_time: '5 dias, 3 horas, 35 minutos e 8 segundos',
        card_total_time: '11 dias, 3 horas, 50 minutos e 33 segundos'
      }
    ]
  }
]
```
