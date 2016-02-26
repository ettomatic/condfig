module Condfig
  require 'redis'

  class ConfigRepository
    def self.all
      db.keys
    end

    def self.search(id)
      db.get(id)
    end

    def self.store(id, config)
      db.set(id, config)
    end

    def self.remove(id)
      db.del(id)
    end

    def self.db
      @redis ||= Redis.new
    end
  end
end
