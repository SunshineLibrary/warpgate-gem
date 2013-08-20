class Warpgate
  def self.setup
    puts 'hi'
  end

  def self.sendTask task={}
    unless task.id and task.action
      return
    end
  end
end
