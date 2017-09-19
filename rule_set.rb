require 'pry-byebug'

module RulesEngine
  module Core
    class RuleSet
      attr_accessor :title, :description, :rules, :results
      attr_reader   :created_at

      def initialize(title, description)
        @created_at = Time.now
        @title = title || 'RuleSet title'
        @description = description || 'RuleSet description'
        @rules = []
        @results = []
      end

      def metadata
        { 
          id: self.object_id, 
          created_at: @created_at, 
          title: @title, 
          description: @description,
          rules: @rules,
          results: @results
        }
      end

      def add_rule(rule)
        if rule.class == Rule
          @rules.push(rule)
        end
      end

      def apply_all
        @rules.each_with_index do |rule, index| 
          @results.push(rule.apply)
        end
        self
      end

      def next
        binding.pry
        @results.next
      end

      def previous
        @results.previous
      end
    end
  end
end