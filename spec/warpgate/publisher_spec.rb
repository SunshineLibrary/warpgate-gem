require 'spec_helper'

describe Publisher do
  let :connection_params do
    {
      host: 'localhost',
      port: 5672,
      vhost: '/',
      username: 'guest',
      password: 'guest'
    }
  end

  let :publisher do
    Publisher.new connection_params
  end

  describe "when connecting" do
    it "attempts connection 3 times if unsuccessful" do
      conn = Bunny.new
      conn.should_receive(:start).exactly(3).times.and_throw 'error'
      Bunny.should_receive(:new).once.and_return conn
      publisher.connection
    end

    it "attempts connection once if unsuccessful" do
      conn = Bunny.new
      conn.should_receive(:start).once.and_return(true)
      Bunny.should_receive(:new).once.and_return(conn)
      publisher.connection
    end

    it "attempts to create channel 3 times if unsuccessful" do
      conn = Bunny.new
      conn.should_receive(:'open?').twice.and_return(true)
      conn.should_receive(:create_channel).exactly(3).times.and_throw('error')
      Bunny.should_receive(:new).and_return(conn)
      publisher.channel
    end

    it "attempts to create channel once if successful" do
      channel = double(Bunny::Channel)
      conn = Bunny.new
      conn.should_receive(:'open?').twice.and_return(true)
      conn.should_receive(:create_channel).once.and_return(channel)
      Bunny.should_receive(:new).and_return(conn)
      publisher.channel.should == channel
    end
  end

  describe "when publishing task" do
    it "should ignore task without id and action" do
      publisher.publish.should == false
    end

    it "should publish to log when disabled" do
      publisher.enabled = false
      publisher.should_receive(:publish_log)
      publisher.publish({id:1, action:'simple'})
    end

    it "should publish to log when exchange could not be connected" do
      publisher.should_receive(:exchange).and_return(nil)
      publisher.should_receive(:publish_log)
      publisher.publish({id:1, action:'simple', role: 'local'})
    end

    it "should publish to role when role present" do
      to_role = 'local'
      task = {id:1, action:'simple', role: to_role}
      publisher.should_receive(:publish_to_role).with(to_role, task)
      publisher.publish(task)
    end

    it "should publish to host when host present" do
      to_host = 'localhost'
      task = {id:1, action:'simple', host: to_host}
      publisher.should_receive(:publish_to_host).with(to_host, task)
      publisher.publish(task)
    end
  end
end
