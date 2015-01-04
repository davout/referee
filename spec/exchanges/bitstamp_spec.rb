require_relative '../spec_helper'

describe Referee::Exchanges::Bitstamp do

  describe '#connect' do
    it 'should fetch the book and start listening' do
      expect_any_instance_of(PusherClient::Socket).to receive(:connect)
      
      expect(Net::HTTP).to receive(:get).and_return(<<-EOS)
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

      bitstamp = Referee::Exchanges::Bitstamp.new
      bitstamp.connect

      expect(bitstamp.book[:bid].last[0]).to eql(BigDecimal('10'))
      expect(bitstamp.book[:bid].first[0]).to eql(BigDecimal('12'))

      expect(bitstamp.book[:ask].last[0]).to eql(BigDecimal('23'))
      expect(bitstamp.book[:ask].first[0]).to eql(BigDecimal('21'))
    end
  end

end
