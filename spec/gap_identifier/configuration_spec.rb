require 'spec_helper'

describe GapIdentifier::Configuration do
  let(:configuration) { GapIdentifier::Configuration.new }

  describe 'attr_accessors' do
    %w(member_token developer_public_key board_id username).each do |attribute|
      it %Q(responds to #{attribute}) do
        expect(configuration.respond_to? attribute).to be_truthy
      end
    end
  end

  describe '#setup_trello_credentials!' do
    it 'calls Trello.configure block' do
      expect(Trello).to receive(:configure)

      configuration.setup_trello_credentials!
    end
  end
end
