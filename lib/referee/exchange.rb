# encoding: UTF-8
require 'referee/book_side'
require 'colorize'

module Referee
  class Exchange

    attr_accessor :book, :last_market_info, :color

    def initialize
      @book = {
        bid: BookSide.new(:bid).on_update { arbitrage },
        ask: BookSide.new(:ask).on_update { arbitrage }
      }
    end

    def arbitrage
      m = market_info
      if last_market_info.nil? || (last_market_info != m)
        puts(m)
        self.last_market_info = market_info
      end
    end

    def market_info(exchange_rate = 1, curr = nil)
      m = "[#{symbol}] BID: #{short_currency(curr)}#{'%.4f' % (bid * exchange_rate)} | ASK: #{short_currency(curr)}#{'%.4f' % (ask * exchange_rate)} | SPD: #{short_currency(curr)}#{'%.4f' % (spread * exchange_rate)}"
      (color && m.colorize(color: color)) || m
    end

    def bid
      (book[:bid].first && book[:bid].first[0]) || 0
    end

    def ask
      (book[:ask].first && book[:ask].first[0]) || 0
    end

    def spread
      ask - bid
    end

    def short_currency(curr)
      {
        'USD' => '$',
        'EUR' => '€',
        'GBP' => '£'
      }[curr || currency] || '?'
    end

  end
end
