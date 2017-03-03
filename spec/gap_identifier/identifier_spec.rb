require 'spec_helper'

RSpec.describe GapIdentifier::Identifier do
  describe '.cards_exceed_list_average_time' do
    context 'when it finds exceeded cards' do
      before do
        cards = [
          { id: '5824862bd3665336ad7e61f0', name: 'Ajustes & melhorias' }
        ]

        trello_lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)'
          }
        ]

        lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)',
            average_time: 444908
          }
        ]

        cards_list = [
          {
            list: '580f51ba372779f74d8f840a',
            card: '5824862bd3665336ad7e61f0',
            total_time: 964233
          }
        ]

        allow(described_class).to receive(:trello_cards).and_return(cards)
        allow(described_class).to receive(:trello_lists).and_return(trello_lists)
        allow(described_class).to receive(:fetch_lists_average_time).with(cards_list).and_return(lists)
        allow(described_class).to receive(:fetch_cards_list_total_time).with(cards).and_return(cards_list)
      end

      it 'returns expected list' do
        expect(described_class.cards_exceed_list_average_time).to match_array(
          [
            {
              id: '5824862bd3665336ad7e61f0',
              card: 'Ajustes & melhorias',
              lists: [
                {
                  list_id: '580f51ba372779f74d8f840a',
                  list: 'To Do (Especificadas e Priorizadas)',
                  list_average_time: '5 dias, 3 horas, 35 minutos e 8 segundos',
                  card_total_time: '11 dias, 3 horas, 50 minutos e 33 segundos'
                }
              ]
            }
          ]
        )
      end
    end

    context 'when does not find exceeded card' do
      before do
        cards = [
          { id: '5824862bd3665336ad7e61f0', name: 'Ajustes & melhorias' }
        ]

        trello_lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)'
          }
        ]

        lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)',
            average_time: 444908
          }
        ]

        cards_list = [
          {
            list: '580f51ba372779f74d8f840a',
            card: '5824862bd3665336ad7e61f0',
            total_time: 1200
          }
        ]

        allow(described_class).to receive(:trello_cards).and_return(cards)
        allow(described_class).to receive(:trello_lists).and_return(trello_lists)
        allow(described_class).to receive(:fetch_lists_average_time).with(cards_list).and_return(lists)
        allow(described_class).to receive(:fetch_cards_list_total_time).with(cards).and_return(cards_list)
      end

      it 'returns an empty list' do
        expect(described_class.cards_exceed_list_average_time).to be_empty
      end
    end

    context 'when card has no relation with an existing list' do
      before do
        cards = [
          { id: '5824862bd3665336ad7e61f0', name: 'Ajustes & melhorias' }
        ]

        trello_lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)'
          }
        ]

        lists = [
          {
            id: '580f51ba372779f74d8f840a',
            name: 'To Do (Especificadas e Priorizadas)',
            average_time: 444908
          }
        ]

        cards_list = []

        allow(described_class).to receive(:trello_cards).and_return(cards)
        allow(described_class).to receive(:trello_lists).and_return(trello_lists)
        allow(described_class).to receive(:fetch_lists_average_time).with(cards_list).and_return(lists)
        allow(described_class).to receive(:fetch_cards_list_total_time).with(cards).and_return(cards_list)
      end

      it 'returns an empty list' do
        expect(described_class.cards_exceed_list_average_time).to be_empty
      end
    end
  end
end
