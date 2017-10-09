require 'pry-byebug'

module RulesEngine
  module Pipelines
    class Branch
      attr_reader :result, :action, :representation

      def initialize(result, action)
        @result = result
        @action = action
      end

      def representation
        { result: @result, action: @action }
      end
    end
  end
end
