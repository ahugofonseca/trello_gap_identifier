require 'spec_helper'

RSpec.describe GapIdentifier::CardsFinder do
  describe '.call' do
    before do
      boards = instance_double Trello::Board
      card   = instance_double Trello::Card

      allow(card).to receive(:id).and_return('580e8e4ea3afcc1593d1285a')
      allow(card).to receive(:name).and_return('Planning')

      allow(GapIdentifier).to receive_message_chain(:configuration, :username).and_return('john_armless')
      allow(GapIdentifier).to receive_message_chain(:configuration, :board_id).and_return(12)

      allow(Trello::Member).to receive_message_chain(:find, :boards, :[]).with(12).and_return(boards)
      allow(boards).to receive(:cards).and_return([card])
    end

    it 'returns expected cards' do
      response = described_class.call

      expect(response).to match_array(
        [
          { id: '580e8e4ea3afcc1593d1285a', name: 'Planning' }
        ]
      )
    end
  end
end
