require 'spec_helper'

describe GapIdentifier do
  describe '.configure' do
    let(:configuration) { GapIdentifier::Configuration.new }

    before do
      allow(described_class).to receive(:configuration).and_return(configuration)
    end

    it 'yields GapIdentifier::Configuration' do
      expect do
        |config| GapIdentifier.configure(&config)
      end.to yield_with_args(configuration)
    end
  end
end
