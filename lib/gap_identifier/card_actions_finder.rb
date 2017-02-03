module GapIdentifier
  class CardActionsFinder
    class << self
      def call(card)
        card_actions = []

        Trello::Card.find(card[:id]).actions.each do |action|
          card_action = {}
          card_action[:action_time] = action.date

          if create_action?(action)
            card_action[:to] = action.data['list']['id']

            card_actions << card_action
          elsif valid_update_action?(action)
            card_action[:from] = action.data['listBefore']['id']
            card_action[:to]   = action.data['listAfter']['id']

            card_actions << card_action
          end
        end

        card_actions.sort_by! { |h| h[:action_time] }
      end

      private

      def create_action?(action)
        action.type == 'createCard'
      end

      def valid_update_action?(action)
        action.type == 'updateCard' && has_update_params?(action)
      end

      def has_update_params?(action)
        action.data['listBefore'].present? && action.data['listAfter'].present?
      end
    end
  end
end
