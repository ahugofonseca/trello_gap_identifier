require 'spec_helper'

RSpec.describe GapIdentifier::ListsAverageTimeCalculator do
  let(:subject) do
    cards_list = [
      {
        list: 2,
        card: 1,
        total_time: 60
      }
    ]

    lists = [{ id: 2}]

    described_class.new(cards_list, lists)
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


  describe '#call' do
    before do
      allow(subject).to receive(:calc_list_total_time_and_counter).and_return([30, 2])
    end

    it 'calls ListsAverageTimeCalculator#calc_list_total_time_and_counter' do
      expect(subject).to receive(:calc_list_total_time_and_counter).and_return([30, 2])

      cards_list = [list: 1, total_time: 30]

      subject.call
    end

    it 'calculates list average time' do
      cards_list = [list: 1, total_time: 30]

      results_list = subject.call

      expect(results_list.first[:average_time]).to eq 15
    end
  end
end
