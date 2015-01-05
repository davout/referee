module Referee
  class BookSide < Array

    attr_accessor :side

    def initialize(side)
      if [:bid, :ask].include?(side)
        self.side = side
      else
        raise 'Incorrect side provided'
      end
    end

    def get_depth_at(price)
      depth = 0
      i     = 0

      while ((length > i) && (depth == 0 || ((buying? && self[i][0] > price) || (selling? && self[i][0] < price)))) do
        if self[i][0] == price
          depth = self[i][1]
        end

        i += 1
      end

      depth
    end

    def set_depth_at(price, depth)
      prev = (self[0] && self[0][0]) || 0

      if get_depth_at(price).zero?
        idx = 0

        unless depth.zero?
          while ((length > idx) && ((buying? && (self[idx][0] > price)) || (selling? && (self[idx][0] < price)))) do
            idx += 1
          end

          insert(idx, [price, depth])
        end
      else
        idx = index do |i|
          i[0] == price
        end
        if depth.zero?
          delete_at(idx)
        else
          self[idx][1] = depth
        end
      end

      if (self[0][0] != prev)
        do_on_update
      end
    end

    def buying?
      side == :bid
    end

    def selling?
      !buying?
    end

    def on_update(&block)
      @update_callback = block
    end

    def do_on_update
      @update_callback && @update_callback.call
    end

  end
end
