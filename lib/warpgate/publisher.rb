class Publisher

  attr_accessor :connection_params, :enabled

  def initialize(connection_params={}, enabled=true)
    self.connection_params = connection_params
    self.enabled = enabled

    begin
      @logger = Rails.logger
    rescue
      @logger = Logger.new STDOUT
    end
  end

  def publish(task={})
    if not task[:id] or not task[:action]
      false
    elsif not enabled
      publish_log(task, 'Warpgate is disabled')
    elsif task[:role]
      return publish_to_role(task[:role], task)
    elsif task[:host]
      return publish_to_host(task[:host], task)
    else
      false
    end
  end

  def publish_to_role(to_role, task)
    exchange_name = 'warpgate.role.' + to_role
    publish_to_exchange(exchange(exchange_name), task)
  end

  def publish_to_host(to_host, task)
    routing_key = 'warpgate.host.' + to_host
    publish_to_exchange(exchange, task, routing_key: routing_key)
  end

  def publish_to_exchange(exchange, task, options={})
    if exchange
      message = (task[:params] || {}).to_json
      options[:type] = task[:action]
      options[:message_id] = task[:id].to_s
      options[:content_type] = 'application/json'
      options[:app_id] = 'warpgate'
      exchange.publish(message, options)
    else
      publish_log(task, reason='Warpgate could not connect to exchange')
    end
  end

  def publish_log(task, reason='unknown')
    @logger.info 'Warpgate received task: ' + task.to_s
    @logger.warn 'Task not sent: ' + reason
  end

  def exchange(exchange_name=nil)
    begin
      if exchange_name
        channel.fanout(exchange_name, durable: true, exculsive: false, auto_delete: false)
      else
        channel.default_exchange
      end
    rescue Exception => e
      @logger.error(e)
      nil
    end
  end

  def channel
    unless @channel and @channel.open?
      if connection.open?
        if @channel
          attempt(3) { @channel.open }
        else
          attempt(3) { @channel = @connection.create_channel}
        end
      end
    end
    @channel
  end

  def connection
    @connection ||= Bunny.new connection_params
    attempt(3) { @connection.start } unless @connection.open?
    @connection
  end

  def attempt(num)
    num.times do
      begin
        break if yield
      rescue
        next
      end
    end
  end
end

require 'bunny'
require 'json'
