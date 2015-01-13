require 'bigdecimal'
require 'em-http-request'
require 'websocket-eventmachine-client'
require 'oj'

require 'referee/exchange'

module Referee
  module Exchanges
    class Bitstamp < Referee::Exchange

      ORDER_BOOK_KEY = 'de504dc5763aeef9ff52' 
      FULL_BOOK_URL  = 'https://www.bitstamp.net/api/order_book/'

      FEE = 0 #BigDecimal('0.005')

      def symbol
        'BSTP'
      end

      def currency
        'USD'
      end

      def connect
        http = EM::HttpRequest.new(FULL_BOOK_URL).get

        http.callback do
          read_full_depth(http)
          connect_ws
        end
      end

      def read_full_depth(http)
        full_book = Oj.load(http.response)

        full_book['bids'].each do |t|
          book[:bid].set_depth_at(BigDecimal(t[0]) * (1 - FEE), BigDecimal(t[1]))
        end

        full_book['asks'].each do |t|
          book[:ask].set_depth_at(BigDecimal(t[0]) * (1 + FEE), BigDecimal(t[1]))
        end
      end

      def connect_ws
        ws = WebSocket::EventMachine::Client.connect(uri: "ws://ws.pusherapp.com:80/app/#{ORDER_BOOK_KEY}?client=brainfuck&version=1.3.7&protocol=6")

        ws.onopen do
          msg = Oj.dump({ 'event' => 'pusher:subscribe', 'data' => { 'channel' => 'diff_order_book' }})
          ws.send(msg)
        end

        ws.onmessage do |msg, type|
          j = Oj.load(msg)

          if j['event'] == 'data'
            data = Oj.load(j['data'])

            data['bids'].each do |bid|
              book[:bid].set_depth_at(BigDecimal(bid[0]) * (1 - FEE), BigDecimal(bid[1]))
            end

            data['asks'].each do |ask|
              book[:ask].set_depth_at(BigDecimal(ask[0]) * (1 + FEE), BigDecimal(ask[1]))
            end
          end

        end
      end
    end
  end
end
