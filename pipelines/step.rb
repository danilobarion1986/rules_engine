require 'pry-byebug'
require_relative 'branch'

module RulesEngine
  module Pipelines
    class Step
      include RulesEngine::Pipelines

      attr_reader :branchs

      def initialize
        @branchs = []
      end

      def add_branch(branch)
        return if branch.class != Branch  
        @branchs.push(branch)
        self  
      end

      def add_branchs(branchs)
        return if branchs.class != Array  
        branchs.each { |branch| add_branch(branch) }
        self  
      end

      def representation
        r = { branchs: {} }
        @branchs.each_with_index do |branch, index|
          r[:branchs].store(index, branch.representation)
        end
        r
      end
    end
  end
end