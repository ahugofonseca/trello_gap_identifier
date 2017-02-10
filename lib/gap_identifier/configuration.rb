require 'trello'

module GapIdentifier
  class Configuration
    attr_accessor :member_token, :developer_public_key, :board_id, :username

    def setup_trello_credentials!
      Trello.configure do |config|
        config.developer_public_key = developer_public_key
        config.member_token = member_token
      end
    end
  end
end
