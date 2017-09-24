require 'pry-byebug'

module RulesEngine
  module Core
    class RuleSet
      attr_reader :title, :description, :created_at, :rules, :results

      def initialize(title, description)
        @created_at = Time.now
        @title = title || :ruleset_title
        @description = description || 'RuleSet description'
        @rules = []
        @results = []
        @r = nil
      end

      def metadata
        { id: object_id, created_at: @created_at, title: @title,
          description: @description, rules: @rules, results: @results }
      end

      def add_rule(rule)
        @rules.push(rule) if rule.class == Rule
      end

      def del_rule(rule)
        @rules.delete(rule)
      end

      def apply_rule(rule)
        @r = @rules.select { |x| x.object_id == rule.object_id }.first
        self
      end

      def to(subject)
        @r.apply_to(subject)
        @results.push(rule: @r, result: @r.apply_to(subject).result)
        self
      end

      def apply_all_to(subject)
        @rules.each do |rule|
          @results.push(rule: rule, result: rule.apply_to(subject).result)
        end
        self
      end
    end
  end
end
