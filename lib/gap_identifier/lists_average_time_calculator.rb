module GapIdentifier
  class ListsAverageTimeCalculator
    def self.call(cards_list, lists)
      new(cards_list, lists).call
    end

    def initialize(cards_list, lists)
      @cards_list = cards_list
      @lists = lists
    end

    def call
      list_card_size = @cards_list.count - 1

      @lists.each do |list|
        total_time, count = calc_list_total_time_and_counter(
          list[:id], @cards_list, list_card_size
        )

        list[:average_time] = if count > 0
                                total_time / count
                              else
                                total_time
                              end
      end

      @lists
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
