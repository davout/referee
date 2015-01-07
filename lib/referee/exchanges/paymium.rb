require 'referee/exchange'
require 'referee/fix_connection'

module Referee
  module Exchanges
    class Paymium < Referee::Exchange

      FIX_SERVER  = 'fix.paymium.com'
      FIX_PORT    = 8359

      def symbol
        'PAYM'
      end

      def currency
        'EUR'
      end

      def connect
        FE::Logger.logger.level = Logger::WARN

        EM.connect(FIX_SERVER, FIX_PORT, FixConnection) do |conn|
          conn.target_comp_id = 'PAYMIUM'
          conn.comp_id        = 'BC-U458625'
          conn.username       = 'BC-U458625'
          conn.exchange       = self
        end
      end

    end
  end
end

