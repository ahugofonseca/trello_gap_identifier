module GapIdentifier
  class ListsFinder
    class << self
      def call
        lists = []

        trello_lists.each do |list|
          lists << {
              id:   list.id,
              name: list.name
            }
        end

        lists
      end

      private

      def trello_lists
        Trello::Member
          .find(GapIdentifier.configuration.username)
          .boards[GapIdentifier.configuration.board_id]
          .lists
      end
    end
  end
end
