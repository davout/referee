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

  end
end
