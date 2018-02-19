require 'pry-byebug'
require_relative 'step'

module RulesEngine
  module Pipelines
    class Flow
      include RulesEngine::Pipelines

      attr_reader :steps, :created_at

      def initialize
        @created_at = Time.now
        @steps = []
      end

      def add_step(step)
        return if step.class != Step
        @steps.push(step)
        self
      end

      def add_steps(steps)
        return if steps.class != Array
        steps.each { |step| add_step(step) }
        self
      end

      def metadata
        { id: object_id, created_at: @created_at, steps: @steps }
      end

      def representation
        r = { steps: {} }
        @steps.each_with_index do |step, index|
          r[:steps].store(index, step.representation)
        end
        r
      end

      def execute_for(subject)
        @steps.each do |step|
          step.verify_for(subject)
        end
      end
    end
  end
end
