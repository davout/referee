require 'fix/engine'

module Referee

  class FixConnection < FE::ClientConnection

    attr_accessor :msg_received

    def on_logon
      mdr = FP::Messages::MarketDataRequest.new

      mdr.md_req_id = 'foo'

      mdr.subscription_request_type = :updates
      mdr.market_depth              = :full
      mdr.md_update_type            = :incremental

      mdr.instruments.build do |i|
        i.symbol = 'EUR/XBT'
      end

      [:bid, :ask, :trade, :open, :vwap, :close].each do |mdet|
        mdr.md_entry_types.build do |m|
          m.md_entry_type = mdet
        end
      end

      send_msg(mdr)
    end

    def on_message(msg)
      msg_received && msg_received.call(msg)
    end

  end
end
