require 'spec_helper'

describe Cinch::Plugins::Rabbit do
  include Cinch::Test

  before(:each) do
    ['/tmp/rabbit_subs_file.yml', '/tmp/rabbit_links_file.yml'].each do |file|
      File.delete(file) if File.exist?(file)
    end
    @bot = make_bot(Cinch::Plugins::Rabbit)
  end

  describe 'subscriptions' do
    it 'should allow users to subscribe' do
      msg = make_message(@bot, '!rabbits subscribe')
      expect(get_replies(msg).first.text).to include("You are now subscribed")
    end

    it 'should allow users to subscribe' do
      get_replies(make_message(@bot, '!rabbits subscribe'))
      expect(Cinch::Plugins::Rabbit::Subscription.list.length).to eq(1)
    end

    it 'should inform users that they already subscribed' do
      get_replies(make_message(@bot, '!rabbits subscribe'))
      msg = make_message(@bot, '!rabbits subscribe')
      expect(get_replies(msg).first.text).to include("You are already subscribed")
    end

    it 'should allow users to unsubscribe' do
      get_replies(make_message(@bot, '!rabbits subscribe'))
      get_replies(make_message(@bot, '!rabbits unsubscribe'))
      expect(Cinch::Plugins::Rabbit::Subscription.list.length).to be_zero
    end

    it 'should inform users that they are not subscribed on an unsubscribe' do
      msg = make_message(@bot, '!rabbits unsubscribe')
      expect(get_replies(msg).first.text).to include("You are not subscribed.")
    end

    #it 'should notify users when a new rabbit is linked' do
    #  get_replies(make_message(@bot, '!rabbits subscribe'), { channel: '#foo', nick: 'joe' } )
    #  msgs = get_replies(make_message(@bot, RabbitLink.url(random_rabbit_id, false), { channel: '#foo', nick: 'josh' }))
    #  msgs.first.should_not be_nil
    #end

    it 'should not notify users when an old rabbit is relinked' do
      get_replies(make_message(@bot, '!rabbits subscribe'), { :channel => '#foo' } )
      get_replies(make_message(@bot, RabbitLink.url(random_rabbit_id, false), { :channel => '#foo' }))
      msg = make_message(@bot, RabbitLink.url(random_rabbit_id, false), { :channel => '#foo' })
      expect(get_replies(msg)).to be_empty
    end
  end

  def random_rabbit_id(len = 6)
    chars = %w{ a b c d e f 0 1 2 3 4 5 6 7 8 9 }
    string = ''
    len.times { string << chars[rand(chars.length)] }
    string
  end
end
