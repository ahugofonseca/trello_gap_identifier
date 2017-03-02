require 'spec_helper'

RSpec.describe GapIdentifier::ListsAverageTimeCalculator do
  let(:subject) { described_class.new }

  before do
    allow(GapIdentifier::CardsFinder).to receive(:call)
    allow(GapIdentifier::ListsFinder).to receive(:call)
  end

  describe 'initialize' do
    it 'calls GapIdentifier::CardsFinder.call' do
      expect(GapIdentifier::CardsFinder).to receive(:call)

      subject
    end

    it 'calls GapIdentifier::ListsFinder.call' do
      expect(GapIdentifier::ListsFinder).to receive(:call)

      subject
    end
  end

  describe '#calc_total_time' do
    it 'calculates the list total time according the number of time pairs' do
      time_pairs_list = [[1, 2]]

      expect(subject.calc_total_time(time_pairs_list)).to eq 1
    end
  end

  describe '#calc_list_total_time_and_counter' do
    context 'when card list id is equal the required list_id' do
      it 'returns total time and counter according with cards_list values' do
        list_id = 1
        cards_list = [list: 1, total_time: 1]
        list_card_size = cards_list.size - 1

        expected_total_time, expected_counter = subject
          .calc_list_total_time_and_counter(list_id, cards_list, list_card_size)

        expect(expected_total_time).to eq 1
        expect(expected_counter).to eq 1
      end
    end

    context 'when card list id is not equal the required list_id' do
      it 'returns 0 total time and 0 counter' do
        list_id = 2
        cards_list = [list: 1, total_time: 1]
        list_card_size = cards_list.size - 1

        expected_total_time, expected_counter = subject
          .calc_list_total_time_and_counter(list_id, cards_list, list_card_size)

        expect(expected_total_time).to eq 0
        expect(expected_counter).to eq 0
      end
    end
  end

  describe '#store_list_average_time' do
    before do
      allow(GapIdentifier::ListsFinder).to receive(:call).and_return([{ id: 1}])
      allow(subject).to receive(:calc_list_total_time_and_counter).and_return([30, 2])
    end

    it 'calls ListsAverageTimeCalculator#calc_list_total_time_and_counter' do
      expect(subject).to receive(:calc_list_total_time_and_counter).and_return([30, 2])

      cards_list = [list: 1, total_time: 30]

      subject.store_list_average_time(cards_list)
    end

    it 'stores list average time on @lists' do
      cards_list = [list: 1, total_time: 30]

      subject.store_list_average_time(cards_list)

      expect(subject.instance_eval('@lists').first[:average_time]).to eq 15
    end
  end

  describe '#fetch_list_time_pairs' do
    context 'when it finds pair' do
      it 'returns time pairs list' do
        card_actions_list = [
          {
            action_time: "2014-04-08T18:50:15.000Z",
            from: 1,
            to: 2
          },
          {
            action_time: "2014-04-08T18:51:15.000Z",
            from: 2,
            to: 3
          }
        ]

        list = { id: 2 }

        result = subject.fetch_list_time_pairs(list, card_actions_list)

        expect(result).to match_array([["2014-04-08T18:50:15.000Z", "2014-04-08T18:51:15.000Z"]])
      end
    end

    context 'when it does not find pair' do
      it 'returns an empty list' do
        card_actions_list = [
          {
            action_time: "2014-04-08T18:50:15.000Z",
            from: 1,
            to: 2
          }
        ]

        list = { id: 2 }

        result = subject.fetch_list_time_pairs(list, card_actions_list)

        expect(result).to be_empty
      end
    end

    context 'when it has multiple actions' do
      it 'does not overwrite pair time when it finds one' do
        card_actions_list = [
          {
            action_time: "2014-04-08T18:50:15.000Z",
            from: 1,
            to: 2
          },
          {
            action_time: "2014-04-08T18:51:15.000Z",
            from: 2,
            to: 3
          },
          {
            action_time: "2014-04-08T18:52:15.000Z",
            from: 2,
            to: 3
          }
        ]

        list = { id: 2 }

        result = subject.fetch_list_time_pairs(list, card_actions_list)

        expect(result).to match_array([["2014-04-08T18:50:15.000Z", "2014-04-08T18:51:15.000Z"]])
      end
    end
  end

  describe '#trello_card_actions' do
    let(:card) do
      { id: '580e8e4ea3afcc1593d1285a' }
    end

    let(:card_actions_list) do
      [
        {
          action_time: "2014-04-08T18:50:15.000Z",
          from: 1,
          to: 2
        }
      ]
    end

    before do
      allow(GapIdentifier::CardActionsFinder).to receive(:call)
        .with(card)
        .and_return(card_actions_list)
    end

    it 'calls GapIdentifier::CardActionsFinder.call' do
      expect(GapIdentifier::CardActionsFinder).to receive(:call)
        .with(card)
        .and_return(card_actions_list)

      subject.trello_card_actions(card)
    end
  end
end
