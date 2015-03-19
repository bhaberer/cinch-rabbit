# Cinch::Plugins::Rabbit

[![Gem Version](https://badge.fury.io/rb/cinch-rabbit.png)](http://badge.fury.io/rb/cinch-rabbit)
[![Dependency Status](https://gemnasium.com/bhaberer/cinch-rabbit.png)](https://gemnasium.com/bhaberer/cinch-rabbit)
[![Build Status](https://travis-ci.org/bhaberer/cinch-rabbit.png?branch=master)](https://travis-ci.org/bhaberer/cinch-rabbit)
[![Coverage Status](https://coveralls.io/repos/bhaberer/cinch-rabbit/badge.png?branch=master)](https://coveralls.io/r/bhaberer/cinch-rabbit?branch=master)
[![Code Climate](https://codeclimate.com/github/bhaberer/cinch-rabbit.png)](https://codeclimate.com/github/bhaberer/cinch-rabbit)

Cinch Plugin for tracking Rabbit URLs linked in the channel.

## Installation

Add this line to your application's Gemfile:

    gem 'cinch-rabbit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-rabbit

## Usage

Just add the plugin to your list:

    @bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [Cinch::Plugins::Rabbit]
      end
    end

Then in channel use !rabbit to get notifications of the rabbit that have been linked recently.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
