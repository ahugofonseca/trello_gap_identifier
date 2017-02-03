require 'spec_helper'

RSpec.describe GapIdentifier::CardActionsFinder do
  describe '.call' do
    let(:action) { instance_double(Trello::Action) }
    let(:card)   { { id: '580e8e4ea3afcc1593d1285a' } }

    before do
      allow(Trello::Card).to receive_message_chain(:find, :actions).and_return([action])
      allow(action).to receive(:date).and_return('2014-04-08T18:50:15.000Z')
      allow(action).to receive(:data).and_return(data)
    end

    context 'update actions' do
      let(:data) do
        {
          'listBefore' => {
            'id' => 1
          },
          'listAfter' => {
            'id' => 2
          }
        }
      end

      before do
        allow(action).to receive(:type).and_return('updateCard')
      end

      it 'calls Trello::Card actions' do
        expect(Trello::Card).to receive_message_chain(:find, :actions).and_return([action])

        described_class.call(card)
      end

      it 'returns expected actions' do
        expect(described_class.call(card)).to match_array(
          [
            {
              :action_time => "2014-04-08T18:50:15.000Z",
              :from => 1,
              :to => 2
            }
          ]
        )
      end
    end

    context 'create actions' do
      let(:data) do
        {
          'list' => {
            'id' => 1
          }
        }
      end

      before do
        allow(action).to receive(:type).and_return('createCard')
      end

      it 'calls Trello::Card actions' do
        expect(Trello::Card).to receive_message_chain(:find, :actions).and_return([action])

        described_class.call(card)
      end

      it 'returns expected actions' do
        expect(described_class.call(card)).to match_array(
          [
            { :action_time => "2014-04-08T18:50:15.000Z",
              :to => 1
            }
          ]
        )
      end
    end
  end
end
