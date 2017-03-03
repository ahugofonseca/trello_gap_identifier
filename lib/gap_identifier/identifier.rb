module GapIdentifier
  module Identifier
    class << self
      def cards_exceed_list_average_time
        cards           = trello_cards
        cards_list      = fetch_cards_list_total_time(cards)
        cards_list_size = cards_list.count - 1
        lists           = fetch_lists_average_time(cards_list)

        cards_list.sort_by! { |h| h[:card] }

        exceeded_cards_list = []

        cards.each do |card|
          exceeded_card = { id: card[:id], card: card[:name], lists: [] }

          (0..cards_list_size).each do |index|
            next unless cards_list[index][:card] == card[:id]

            lists.each do |list|
              next unless exceeded_card?(cards_list[index], list)
              exceeded_card[:lists] << {
                list_id:           list[:id],
                list:              list[:name],
                list_average_time: format_time(list[:average_time]),
                card_total_time:   format_time(cards_list[index][:total_time])
              }
            end
          end

          exceeded_cards_list << exceeded_card if exceeded_card[:lists].any?
        end

        exceeded_cards_list
      end

      def exceeded_card?(card, list)
        card[:list] == list[:id] && card[:total_time] > list[:average_time] && list[:average_time] > 0
      end

      def format_time(time)
        GapIdentifier::TimeFormatter.call(time)
      end

      private

      def trello_lists
        GapIdentifier::ListsFinder.call
      end

      def trello_cards
        GapIdentifier::CardsFinder.call
      end

      def fetch_cards_list_total_time(cards)
        GapIdentifier::CardsListTotalTimeCalculator.new(cards, trello_lists).call
      end

      def fetch_lists_average_time(cards_list)
        GapIdentifier::ListsAverageTimeCalculator.new(cards_list, trello_lists).call
      end
    end
  end
end
