module GapIdentifier
  class CardsFinder
    class << self
      def call
        cards = []

        trello_cards.each do |card|
          cards << {
            id:   card.id,
            name: card.name
          }
        end

        cards
      end

      private

      def trello_cards
        Trello::Member
          .find(GapIdentifier.configuration.username)
          .boards[GapIdentifier.configuration.board_id]
          .cards
      end
    end
  end
end
