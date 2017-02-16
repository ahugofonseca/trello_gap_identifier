require 'spec_helper'

RSpec.describe GapIdentifier::TimeFormatter do
  describe '.call' do
    it 'formats expected time' do
      time = 13124123123
      formatted_time = '151899 dias, 13 horas, 45 minutos e 23 segundos'

      expect(described_class.call(time)).to eq(formatted_time)
    end
  end
end
