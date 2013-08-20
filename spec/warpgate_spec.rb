require 'spec_helper'

describe Warpgate do
  let :role do
    'local'
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

  it "set up fields correctly" do
    wg.role.should == role
    wg.salt.should == salt
    wg.connection_params.should == connection_params
  end

  it "publishes task through a publisher" do
    task = {id: 1234, action: 'hello', role: 'role'}
    publisher = double(Publisher)
    publisher.should_receive(:publish).with(task)
    Publisher.should_receive(:new).and_return(publisher)
    Warpgate.publish task
  end
end
