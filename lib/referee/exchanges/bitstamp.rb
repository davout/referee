require 'bigdecimal'
require 'pusher-client'
require 'oj'
require 'net/https'

require 'referee/exchange'

module Referee
  module Exchanges
    class Bitstamp < Referee::Exchange

      ORDER_BOOK_KEY = 'de504dc5763aeef9ff52' 
      FULL_BOOK_URL  = 'https://www.bitstamp.net/api/order_book/'

      def initialize
        super
        PusherClient.logger.level = Logger::INFO
      end

      def connect
        options = { secure: true } 
        socket = PusherClient::Socket.new(ORDER_BOOK_KEY, options)

        socket.subscribe('diff_order_book')

        socket.bind('data') { |data| puts(data) }

        full_book = Oj.load(Net::HTTP.get(URI.parse(FULL_BOOK_URL)))

        full_book['bids'].each do |t|
          book[:bid].set_depth_at(BigDecimal(t[0]), BigDecimal(t[1]))
        end

        full_book['asks'].each do |t|
          book[:ask].set_depth_at(BigDecimal(t[0]), BigDecimal(t[1]))
        end

        socket.connect
      end
    end
  end
end
