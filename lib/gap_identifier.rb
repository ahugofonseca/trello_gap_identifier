require 'trello'
require 'gap_identifier/card_actions_finder'
require 'gap_identifier/cards_finder'
require 'gap_identifier/lists_finder'
require 'gap_identifier/configuration'

module GapIdentifier
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield configuration

    self.configuration.setup_trello_credentials!
  end
end
