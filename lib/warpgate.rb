class Warpgate

  attr_accessor :role, :salt, :enabled, :connection_params

  def initialize
    self.enabled = true
  end

  def self.setup
    @@singleton = Warpgate.new
    yield @@singleton
  end

  def self.publish task={}
    @@singleton.publish task
  end

  def publish(task)
    @publisher ||= Publisher.new(connection_params, enabled)
    @publisher.publish task
  end

  def self.instance
    @@singleton
  end
end

require 'warpgate/publisher'
