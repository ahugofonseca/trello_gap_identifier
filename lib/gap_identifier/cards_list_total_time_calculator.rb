module GapIdentifier
  class CardsListTotalTimeCalculator
    def self.call(cards, lists)
      new(cards, lists).call
    end

    def call
      cards_list = []
      @cards.each do |card|
        card_actions_list = trello_card_actions(card)

        @lists.each do |list|
          time_pairs_list = fetch_list_time_pairs(list, card_actions_list)
          total_time      = calc_total_time(time_pairs_list)

          next unless total_time > 0

          cards_list << {
            list:       list[:id],
            card:       card[:id],
            total_time: total_time
          }
        end
      end

      cards_list
    end

    def initialize(cards, lists)
      @cards = cards
      @lists = lists
    end

    def calc_total_time(time_pairs_list)
      total_time = 0

      time_pairs_list.each do |time_pair|
        total_time += (time_pair.last - time_pair.first).round
      end

      total_time
    end

    def fetch_list_time_pairs(list, card_actions_list)
      actions_size = card_actions_list.count - 1
      time_pairs_list = []

      (0..actions_size).each do |index|
        break if index == actions_size

        # We do a reverse calc to discovery how much time a card stays on this list
        # begin_action[:action_time] is the reference when card arrived on the list
        # final_action[:action_time] is the reference when card take off the list

        # Finds begin_action pair
        if card_actions_list[index][:to] == list[:id]
          begin_action = card_actions_list[index]

          ((index+1)..actions_size).each do |new_index|
            # Finds final_action pair
            if card_actions_list[new_index][:from] == list[:id]
              final_action = card_actions_list[new_index]

              time_pairs_list << [begin_action[:action_time], final_action[:action_time]]

              break # Avoid to replace value when there are more than one action on this loop
            end
          end
        end
      end

      time_pairs_list
    end

    def trello_card_actions(card)
      GapIdentifier::CardActionsFinder.call(card)
    end
  end
end
