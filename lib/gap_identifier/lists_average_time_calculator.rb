module GapIdentifier
  class ListsAverageTimeCalculator
    def self.call
      new.call
    end

    def initialize
      @cards = GapIdentifier::CardsFinder.call
      @lists = GapIdentifier::ListsFinder.call
    end

    def calc_total_time(time_pairs_list)
      total_time = 0

      time_pairs_list.each do |time_pair|
        total_time += (time_pair.last - time_pair.first).round
      end

      total_time
    end

    def calc_list_total_time_and_counter(list_id, cards_list, list_card_size)
      count, total_time = 0, 0

      (0..list_card_size).each do |index|
        next unless cards_list[index][:list] == list_id

        total_time += cards_list[index][:total_time]
        count      += 1
      end

      return total_time, count
    end
  end
end
