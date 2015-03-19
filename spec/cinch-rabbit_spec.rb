require 'spec_helper'

describe Cinch::Plugins::Rabbit do
  include Cinch::Test

  before(:each) do
    ['/tmp/rabbit_subs_file.yml', '/tmp/rabbit_links_file.yml'].each do |file|
      File.delete(file) if File.exist?(file)
    end
    @bot = make_bot(Cinch::Plugins::Rabbit)
  end

  describe 'handling rabbit links' do
    it 'should return an error if no one has linked a rabbit' do
      msg = get_replies(make_message(@bot, '!rabbits', { channel: '#foo' }))
      expect(msg.first.text).to eq("No rabbits have been linked recently!")
    end

    it 'should not capture a malformed (invalid chars) Rabbit link' do
      msg = make_message(@bot, RabbitLink.url('82b5@!'), { channel: '#foo' })
      expect(get_replies(msg)).to be_empty
      msg = make_message(@bot, '!rabbits')
      msg = get_replies(msg).first.text
      expect(msg).to eql("No rabbits have been linked recently!")
    end

    it 'should not capture a malformed (short length) Rabbit link' do
      msg = make_message(@bot, RabbitLink.url('82b5'), { channel: '#foo' })
      expect(get_replies(msg)).to be_empty
      msg = make_message(@bot, '!rabbits')
      expect(get_replies(msg).first.text).to eq("No rabbits have been linked recently!")
    end

    it 'should capture a legit Rabbit link and store it in @storage' do
      msg = make_message(@bot, RabbitLink.url('82b512'), { channel: '#foo' })
      expect(get_replies(msg)).to be_empty
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!rabbits')
      reply = get_replies(msg).last.text
      expect(reply).to include('test started a rabbit at')
      expect(reply).to match(/it was last linked \d seconds? ago/)
    end

=begin

    it 'should capture a legit Rabbit link if it has trailing params' do
      msg = make_message(@bot, RabbitLink.url(random_rabbit_id + '?hl=en', false), { channel: '#foo' })
      get_replies(msg)
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!rabbits')
      reply = get_replies(msg).last.text
      expect(reply).to include "test started a rabbit at"
      expect(reply).to match(/it was last linked \d seconds? ago/)
    end

    it 'should recapture a legit Rabbit link' do
      id = random_rabbit_id
      msg = make_message(@bot, RabbitLink.url(id, false), { channel: '#foo' })
      get_replies(msg)
      sleep 1 # hack until 'time-lord' fix gets released
      get_replies(msg)
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!rabbits')
      reply = get_replies(msg).length
      expect(reply).to eq(2)
    end
=end
  end
end
