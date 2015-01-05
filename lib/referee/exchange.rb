# encoding: UTF-8
require 'referee/book_side'

module Referee
  class Exchange

    attr_accessor :book

    def initialize
      @book = {
        bid: BookSide.new(:bid),
        ask: BookSide.new(:ask)
      }
    end

      def market_info
        "[#{symbol}] BID: #{short_currency}#{'%.4f' % bid} | ASK: #{short_currency}#{'%.4f' % ask} | SPD: $#{'%.4f' % spread}"
      end

      def bid
        book[:bid].first[0]
      end

      def ask
        book[:ask].first[0]
      end

      def spread
        book[:ask].first[0] - book[:bid].first[0]
      end

      def short_currency
        {
          'USD' => '$',
          'EUR' => '€',
          'GBP' => '£'
        }[currency] || '?'
      end

  end
end
