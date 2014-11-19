require "digest"

class Equation
  attr_accessor :id, :values

  @@default_values = { "title"      => "",
                       "code"       => "",
                       "created_at" => 0 }

  def initialize(vals={})
    @id = nil

    @values = @@default_values.merge(vals || {})
    @values["created_at"] = Time.now.to_i
  end

  def []=(k,v)
    @values[k] = v
  end

  def [](k)
    @values[k]
  end

  def ==(other)
    other.is_a?(Equation) && self.id == other.id && self.values == other.values
  end

  def save
    return false unless values_valid?

    unless @id
      pk = $redis.incr "equations:pk"
      @id = Digest::MD5.hexdigest(pk.to_s).to_i(16).to_s(36)[0..10]
    end

    $redis.pipelined do
      $redis.sadd "equations", @id
      $redis.set  "equations:#{@id}", JSON.dump(@values)
    end

    true
  end

  def to_hash
    @values.merge(id: @id)
  end

  def self.delete(id)
    if $redis.srem "equations", id
      $redis.del "equations:#{id}"
      true
    else
      false
    end
  end

  def self.find(id)
    equation_exists = $redis.sismember "equations", id

    if equation_exists
      equation = Equation.new

      equation.id     = id
      equation.values = JSON.load $redis.get("equations:#{id}")

      equation
    else
      nil
    end
  end

  def self.update(id, vals={})
    vals = {} unless vals.is_a? Hash

    equation = Equation.find(id)
    return nil unless equation

    vals.each{ |k,v| equation[k] = v }
    equation.save
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

    # valid = false unless @values["title"].is_a?(String) && @values["title"].length > 0
    # valid = false unless @values["code"].is_a?(String)  && @values["code"].length  > 0

    valid
  end

end
