class MyEnumerator
  def initialize(&block)
    raise ArgumentError unless block_given?

    @fiber = Fiber.new do
      block.call(EnumYielder.new)
    end
  end

  EnumYielder = Struct.new("EnumYielder") do
    def <<(*value)
      Fiber.yield(*value)
    end

    alias_method :yield, :<<
  end

  def take(num)
    ary = []
    num.times do
      ary << self.next
    end

    ary
  end

  def to_a
    array = []
    loop do
      element = self.next
      break if element.nil?
      array << element
    end

    array
  end

  def first
    self.next
  end

  private

  def next
    @fiber.resume
  end
end
