require "./lib/my_enumerator"
require "debug"

describe "MyEnumerator.new" do
  context "no block given" do
    it "raises" do
      -> { MyEnumerator.new(1, :upto, 3) }.should raise_error(ArgumentError)
    end
  end

  context "when passed a block" do
    it "defines iteration with block, yielder argument and calling << method" do
      enum = MyEnumerator.new do |yielder|
        a = 1

        loop do
          yielder << a
          a = a + 1
        end
      end

      enum.take(3).should == [1, 2, 3]
    end

    it "defines iteration with block, yielder argument and calling yield method" do
      enum = MyEnumerator.new do |yielder|
        a = 1

        loop do
          yielder.yield(a)
          a = a + 1
        end
      end

      enum.take(3).should == [1, 2, 3]
    end

    it "defines iteration with block, yielder argument and treating it as a proc" do
      skip "#each_line isn't implemented"

      enum = MyEnumerator.new do |yielder|
        "a\nb\nc".each_line(&yielder)
      end

      enum.to_a.should == ["a\n", "b\n", "c"]
    end

    describe 'yielded values' do
      it 'handles yield arguments properly' do
        MyEnumerator.new { |y| y.yield(1) }.to_a.should == [1]
        MyEnumerator.new { |y| y.yield(1) }.first.should == 1

        MyEnumerator.new { |y| y.yield([1]) }.to_a.should == [[1]]
        MyEnumerator.new { |y| y.yield([1]) }.first.should == [1]

        MyEnumerator.new { |y| y.yield(1, 2) }.to_a.should == [[1, 2]]
        MyEnumerator.new { |y| y.yield(1, 2) }.first.should == [1, 2]

        MyEnumerator.new { |y| y.yield([1, 2]) }.to_a.should == [[1, 2]]
        MyEnumerator.new { |y| y.yield([1, 2]) }.first.should == [1, 2]
      end

      it 'handles << arguments properly' do
        MyEnumerator.new { |y| y.<<(1) }.to_a.should == [1]
        MyEnumerator.new { |y| y.<<(1) }.first.should == 1

        MyEnumerator.new { |y| y.<<([1]) }.to_a.should == [[1]]
        MyEnumerator.new { |y| y.<<([1]) }.first.should == [1]

        MyEnumerator.new { |y| y.<<(1, 2) }.to_a.should == [[1, 2]]
        MyEnumerator.new { |y| y.<<(1, 2) }.first.should == [1, 2]

        MyEnumerator.new { |y| y.<<([1, 2]) }.to_a.should == [[1, 2]]
        MyEnumerator.new { |y| y.<<([1, 2]) }.first.should == [1, 2]
      end
    end
  end
end
