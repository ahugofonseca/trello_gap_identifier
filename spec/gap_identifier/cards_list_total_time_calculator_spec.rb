require 'spec_helper'

RSpec.describe GapIdentifier::CardsListTotalTimeCalculator do
  let(:subject) do
    cards = [{ id: 1}]
    lists = [{ id: 2}]

    described_class.new(cards, lists)
  end

  describe '#calc_total_time' do
    it 'calculates the list total time according the number of time pairs' do
      time_pairs_list = [[1, 2]]

      expect(subject.calc_total_time(time_pairs_list)).to eq 1
    end
  end

  describe '#fetch_list_time_pairs' do
    context 'when it finds pair' do
      it 'returns time pairs list' do
        card_actions_list = [
          {
            action_time: '2014-04-08T18:50:15.000Z',
            from: 1,
            to: 2
          },
          {
            action_time: '2014-04-08T18:51:15.000Z',
            from: 2,
            to: 3
          }
        ]

        list = { id: 2 }

        result = subject.fetch_list_time_pairs(list, card_actions_list)

        expect(result).to match_array([['2014-04-08T18:50:15.000Z', '2014-04-08T18:51:15.000Z']])
      end
    end

    context 'when it does not find pair' do
      it 'returns an empty list' do
        card_actions_list = [
          {
            action_time: '2014-04-08T18:50:15.000Z',
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

        expect(result).to match_array([['2014-04-08T18:50:15.000Z', '2014-04-08T18:51:15.000Z']])
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
          action_time: '2014-04-08T18:50:15.000Z',
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

  describe '#call' do
    before do
      card_actions_list = [
          {
            action_time: '2014-04-08T18:50:15.000Z',
            from: 1,
            to: 2
          },
          {
            action_time: '2014-04-08T18:51:15.000Z',
            from: 2,
            to: 3
          }
        ]

      allow(subject).to receive(:trello_card_actions).and_return(card_actions_list)
      allow(subject).to receive(:fetch_list_times_pair).and_return([['2014-04-08T18:50:15.000Z', '2014-04-08T18:51:15.000Z']])
      allow(subject).to receive(:calc_total_time).and_return(60)
    end

    it 'returns a list of cards total time' do
      expect(subject.call).to match_array(
        [
          {
            list: 2,
            card: 1,
            total_time: 60
          }
        ]
      )
    end
  end
end
