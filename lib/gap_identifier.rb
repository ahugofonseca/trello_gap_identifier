require 'trello'
require 'gap_identifier/cards_list_total_time_calculator'
require 'gap_identifier/lists_average_time_calculator'
require 'gap_identifier/card_actions_finder'
require 'gap_identifier/time_formatter'
require 'gap_identifier/configuration'
require 'gap_identifier/cards_finder'
require 'gap_identifier/lists_finder'
require 'gap_identifier/identifier'

module GapIdentifier
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield configuration

    self.configuration.setup_trello_credentials!
  end

  def self.cards_exceed_list_average_time
    GapIdentifier::Identifier.cards_exceed_list_average_time
  end
end
