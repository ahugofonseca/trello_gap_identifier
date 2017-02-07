require 'spec_helper'

RSpec.describe GapIdentifier::ListsFinder do
  describe '.call' do
    before do
      boards = instance_double Trello::Board
      list   = instance_double Trello::List

      allow(list).to receive(:id).and_return('580e8e4ea3afcc1593d1285a')
      allow(list).to receive(:name).and_return('TO DO')

      allow(GapIdentifier).to receive_message_chain(:configuration, :username).and_return('john_armless')
      allow(GapIdentifier).to receive_message_chain(:configuration, :board_id).and_return(12)

      allow(Trello::Member).to receive_message_chain(:find, :boards, :[]).with(12).and_return(boards)
      allow(boards).to receive(:lists).and_return([list])
    end

    it 'returns expected lists' do
      response = described_class.call

      expect(response).to match_array(
        [
          { id: '580e8e4ea3afcc1593d1285a', name: 'TO DO' }
        ]
      )
    end
  end
end
