# encoding: UTF-8

require 'singleton'

class Warpgate
  include Singleton

  attr_accessor :role, :salt, :enabled, :connection_params

  def initialize
  end

  def self.setup
    self.instance.enabled ||= true
    yield self.instance
  end

  def self.publish task={}
    self.instance.publish task
  end

  def publish(task)
    @publisher = Publisher.new(connection_params, enabled)
    @publisher.publish task
  end

end

require 'warpgate/publisher'
