require "zlib"

class Equation
  attr_accessor :id, :values

  @@default_values = { "code"       => "",
                       "created_at" => 0 }

  ID_BASE = ["A".."Z", "a".."z", 0..9].map(&:to_a).flatten

  def initialize(vals={})
    @id = nil

    @values = @@default_values.merge(vals || {})
    @values["created_at"] = Time.now.to_i
  end

  def ==(other)
    other.is_a?(Equation) && self.id == other.id && self.values == other.values
  end

  def save
    return false unless values_valid?

    loop do
      @id = (0..3).map{ self.class::ID_BASE.sample }.join
      break unless self.class.exists? @id
    end

    json = JSON.dump(@values)

    $redis.pipelined do
      $redis.sadd "equations", @id
      $redis.incr "equations:count"
      $redis.set  @id, Zlib::Deflate.deflate(json)
    end

    true
  end

  def to_hash
    @values.merge(id: @id)
  end

  def self.delete(id)
    if $redis.srem "equations", id
      $redis.del id
      $redis.decr "equations:count"
      true
    else
      false
    end
  end

  def self.exists?(id)
    $redis.sismember "equations", id
  end

  def self.find(id)
    if exists? id
      equation = Equation.new

      json = Zlib::Inflate.inflate $redis.get(id)

      equation.id     = id
      equation.values = JSON.load(json)

      equation
    else
      nil
    end
  end

  private
  def values_valid?
    valid = true

    @values.keys.each do |k|
      unless @@default_values.include?(k)
        valid = false
        break
      end
    end

    valid = false unless @values["code"].is_a?(String)  && @values["code"].length  > 0

    valid
  end

end
