require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

ENV['RABBIT_LINKS_FILE'] = '/tmp/rabbit_links_file.yml'
ENV['RABBIT_SUBSCRIPTIONS_FILE'] = '/tmp/rabbit_subs_file.yml'

[ENV['RABBIT_LINKS_FILE'], ENV['RABBIT_SUBSCRIPTIONS_FILE']].each do |file|
  File.delete(file) if File.exists?(file)
end

require 'cinch-rabbit'
require 'cinch/test'
