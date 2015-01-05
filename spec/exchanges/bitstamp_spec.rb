require_relative '../spec_helper'

describe Referee::Exchanges::Bitstamp do

  before(:each) do
    @bitstamp = Referee::Exchanges::Bitstamp.new
  end

  describe '#connect' do
    it 'should query the full book and connect the ws' do
      @ws = double
      expect(WebSocket::EventMachine::Client).to receive(:connect).and_return(@ws)

      expect(@ws).to receive(:onopen).and_yield
      expect(@ws).to receive(:send).with('{"event":"pusher:subscribe","data":{"channel":"diff_order_book"}}').and_return(nil)

      expect(@ws).to receive(:onmessage).and_yield(<<-EOS, nil)
        {
          "event": "data",
          "data": "{\\"bids\\": [ [\\"4\\", \\"12\\"] ], \\"asks\\": [ [\\"42\\", \\"5\\"] ]}"
        }
      EOS

      EM.run do
        stub_request(:get, 'https://www.bitstamp.net/api/order_book/').
          to_return(status: 200, body: <<-EOS, headers: {})
          {
            "bids": [
              ["10", "10"],
              ["11", "10"],
              ["12", "10"]
            ],
            "asks": [
              ["22", "10"],
              ["23", "10"],
              ["21", "10"]
            ]
          }
        EOS

        @bitstamp.connect
        EM.stop
      end

      expect(@bitstamp.book[:bid].last[0]).to eql(BigDecimal('4'))
      expect(@bitstamp.book[:bid].first[0]).to eql(BigDecimal('12'))

      expect(@bitstamp.book[:ask].last[0]).to eql(BigDecimal('42'))
      expect(@bitstamp.book[:ask].first[0]).to eql(BigDecimal('21'))

      expect(@bitstamp.market_info).
        to eql('[BSTP] BID: $12.0000 | ASK: $21.0000 | SPD: $9.0000')
    end

  end

end
