require 'pry-byebug'

module RulesEngine
  module Core
    class RuleSet
      attr_accessor :title, :description, :rules
      attr_reader   :created_at, :results

      def initialize(title, description)
        @created_at = Time.now
        @title = title || 'RuleSet title'
        @description = description || 'RuleSet description'
        @rules = []
        @results = []
      end

      def metadata
        { id: self.object_id, created_at: @created_at, title: @title,
          description: @description, rules: @rules, results: @results }
      end

      def add_rule(rule)
        @rules.push(rule) if rule.class == Rule
      end

      def del_rule(rule)
        @rules.delete(rule)
      end

      def apply_all
        @rules.each_with_index do |rule, index|
          @results.push({ rule: rule, result: rule.apply.result })
        end
        self
      end
    end
  end
end
