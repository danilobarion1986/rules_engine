require 'pry-byebug'
require_relative 'branch'
require_relative '../core/rule'

module RulesEngine
  module Pipelines
    class Step
      include RulesEngine::Pipelines
      include RulesEngine::Core

      attr_reader :branchs, :rule

      def initialize(title = nil)
        @title = title || ''
        @branchs = []
      end

      def add_rule(rule)
        return if rule.class != Rule
        @rule = rule
        self
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
        r = { rule: @rule, branchs: {} }
        @branchs.each_with_index do |branch, index|
          r[:branchs].store(index, branch.representation)
        end
        r
      end

      def verify_for(subject)
        @rule.apply_to(subject).result
      end
    end
  end
end
