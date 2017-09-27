# https://www.rubyguides.com/2017/08/ruby-linked-list/

module RulesEngine
  module Support
    class Node
      attr_accessor :next
      attr_reader   :value

      def initialize(value)
        @value = value
        @next  = nil
      end

      def to_s
        "Node with value: #{@value}"
      end
    end
  end
end
