require 'referee/exchange'
require 'referee/fix_connection'

module Referee
  module Exchanges
    class Paymium < Referee::Exchange

      FIX_SERVER  = 'fix.paymium.com'
      FIX_PORT    = 8359

      def initialize
        super

        book[:bid].on_update { puts(market_info) }
        book[:ask].on_update { puts(market_info) }
      end

      def symbol
        'PAYM'
      end

      def currency
        'EUR'
      end

      def connect
        FE::Logger.logger.level = Logger::WARN

        EM.connect(FIX_SERVER, FIX_PORT, FixConnection, { server_comp_id: 'PAYMIUM', our_comp_id: 'REFEREE', username: 'REFEREE' }) do |conn| 
          conn.msg_received = Proc.new do |msg|
            if msg.is_a?(FP::Messages::MarketDataSnapshot) || msg.is_a?(FP::Messages::MarketDataIncrementalRefresh)

              msg.md_entries.each do |mde|
                book[mde.md_entry_type].set_depth_at(BigDecimal(mde.md_entry_px), BigDecimal(mde.md_entry_size))
              end

            end
          end
        end
      end

    end
  end
end

