# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/storage'
require 'cinch/toolbox'
require 'time-lord'

module Cinch::Plugins
  # Plugin to track Rabb.it links
  class Rabbit
    include Cinch::Plugin

    attr_accessor :storage

    self.help = 'Use .rabbit to see the info for any recent rabbits. You ' +
                'can also use .rabbit subscribe to sign up for notifications'

    match /(rabbits?|movie)\z/,           method: :list_rabbits
    # match /rabbits subscribe/,   method: :subscribe
    # match /rabbits unsubscribe/, method: :unsubscribe

    listen_to :channel

    # This is the regex that captures rabbit links
    # The regex will need to be updated if the url scheme changes in the future
    RABBIT_REGEX = %r(rabb\.it/r/([a-zA-Z0-9]{6}))

    def initialize(*args)
      super
      @expire = config[:expire_period] || 120
      @response_type = config[:response_type] || :notice
    end

    def listen(m)
      rabbit_id = m.message[RABBIT_REGEX, 1]
      process_rabbit(rabbit_id, m) if rabbit_id
    end

    def process_rabbit(rabbit_id, m)
      if RabbitLink.find_by_id(rabbit_id)
        # If it's an old rabbit capture a new expiration time
        rabbit = RabbitLink.find_by_id(rabbit_id)
        rabbit.time = Time.now
        rabbit.save
      else
        RabbitLink.new(m.user.nick, rabbit_id, Time.now).save
        Subscription.notify(rabbit_id, @bot, @response_type)
      end
    end

    def subscribe(m)
      nick = m.user.nick
      if Subscription.for_user(nick)
        msg = 'You are already subscribed. '
      else
        sub = Subscription.new(nick, @subscription_filename)
        sub.save
        msg = 'You are now subscribed. ' +
              'I will let you know when a rabbit is linked. '
      end
      m.user.notice msg + 'To unsubscribe use `.rabbit unsubscribe`.'
    end

    def unsubscribe(m)
      nick = m.user.nick
      if Subscription.for_user(nick)
        Subscription.for_user(nick).delete
        msg = 'You are now unsubscribed, and will no ' +
              'longer receive a messages. '
      else
        msg = 'You are not subscribed. '
      end
      m.user.notice msg + 'To subscribe use `.rabbit subscribe`.'
    end

    def list_rabbits(m)
      RabbitLink.delete_expired(@expire)
      if RabbitLink.sorted.empty?
        m.user.notice 'No rabbits have been linked recently!'
        return
      end
      m.user.notice 'These rabbits have been linked in the last ' +
                    "#{@expire} minutes. They may or may not still be going."
      RabbitLink.sorted.each do |rabbit|
        m.user.notice "#{rabbit.nick} started a rabbit at " +
                      RabbitLink.url(rabbit.id) +
                      " it was last linked #{rabbit.time.ago.to_words}"
      end
    end
  end
end
