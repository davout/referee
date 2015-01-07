require 'fix/engine'

module Referee

  class FixConnection < EM::Connection

    include FE::ClientConnection

    attr_accessor :exchange

    #
    # When a logon message is received we request a market snapshot
    # and subscribe for continuous updates
    #
    def on_logon(msg)
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

    # Called when a market data snapshot is received
    def on_market_data_snapshot(msg)
      update_book_with(msg)
    end

    # Called upon each subsequent update
    def on_market_data_incremental_refresh(msg)
      update_book_with(msg)
    end

    # Update the local order book copy with the new data
    def update_book_with(msg)
      msg.md_entries.each do |mde|
        exchange.book[mde.md_entry_type].set_depth_at(BigDecimal(mde.md_entry_px), BigDecimal(mde.md_entry_size))
      end
    end

  end
end
