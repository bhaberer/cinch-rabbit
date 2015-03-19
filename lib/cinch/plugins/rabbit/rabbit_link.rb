# -*- encoding : utf-8 -*-
# Class to manage Hangout information
class RabbitLink < Cinch::Plugins::Rabbit
  attr_accessor :nick, :id, :time, :file
  FILENAME = ENV['RABBIT_LINKS_FILE'] || 'yaml/rabbit_links.yml'

  def initialize(nick, id, time)
    @nick = nick
    @id = id
    @time = time
  end

  def save
    storage = Cinch::Storage.new(FILENAME)
    storage.data ||= {}
    storage.data[id] = self
    storage.save
  end

  def self.find_by_id(id)
    listing[id]
  end

  def self.delete_expired(expire_time)
    return if listing.nil?
    storage = read_file
    storage.data.delete_if do |id, rabbit|
      (Time.now - rabbit.time) > (expire_time * 60)
    end
    storage.save
  end

  def self.sorted
    rabbits = listing.values
    rabbits.sort! { |x, y| y.time <=> x.time }
    rabbits
  end

  def self.listing
    read_file.data
  end

  def self.url(id)
    "https://rabb.it/r/#{id}"
  end

  private

  def self.read_file
    storage = Cinch::Storage.new(FILENAME)
    storage.data ||= {}
    storage.save
    storage
  end
end
