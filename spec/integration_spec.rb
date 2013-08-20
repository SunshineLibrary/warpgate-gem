require 'spec_helper'

describe Warpgate do
  let :role do
    'test'
  end

  let :salt do
    'SALT'
  end

  let :connection_params do
    {
      host: 'localhost',
      port: 5672,
      vhost: '/',
      username: 'guest',
      password: 'guest'
    }
  end

  let :wg do
    Warpgate.instance
  end

  before :each do
    Warpgate.setup do |config|
      config.role = role
      config.salt = salt
      config.connection_params = connection_params
      config.enabled = true
    end
  end

  it "publishes task" do
    task = {id: 1, action: 'hello', role: 'test'}
    conn = Bunny.new connection_params
    conn.start
    channel = conn.create_channel
    exchange = channel.fanout('warpgate.role.test', durable:true, exclusive: false, auto_delete: false)
    queue = channel.queue('warpgate.test.localhost', auto_delete: true).bind(exchange)
    queue.should_receive('call')
    queue.subscribe do |delivery_info, metadata, payload|
      puts "Received: " + payload
      queue.call
      queue.delete
    end
    Warpgate.publish task
    sleep 0.1
  end
end
