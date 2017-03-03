# Configure gem to run locally #

## Setup ##

1 - Clone repository and run:
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
    card: 'Adjusts',
    lists: [
      {
        list_id: '580f51ba372779f74d8f840a',
        list: 'To Do',
        list_average_time: '5 days, 3 hours, 35 minutes e 8 seconds',
        card_total_time: '11 days, 3 hours, 50 minutes e 33 seconds'
      }
    ]
  }
]
```
