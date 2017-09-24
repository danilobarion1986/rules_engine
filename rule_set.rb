require 'pry-byebug'
require_relative 'linked_list'

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

      def add(rule)
        @rules.push(rule) unless rule.class != Rule
        self
      end

      def and_apply_to(subject)
        if !@rules.empty?
          applied_rule = @rules.last.apply_to(subject)
          @results.push(rule: applied_rule.title, result: applied_rule.result, errors: applied_rule.errors)
        end
        self
      end

      def add_many(rules)
        rules.each { |rule| add(rule) } unless rules.class != Array 
        self
      end

      def and_apply_all_to(subject)
        apply_all_to(subject)
      end

      def apply_all_to(subject)
        @rules.each do |rule|
          applied_rule = rule.apply_to(subject)
          @results.push(rule: rule.title, result: applied_rule.result, errors: applied_rule.errors )
        end
        self
      end

      def reset
        reset_results
        reset_rules
        self
      end

      def delete(rule)
        @rules.delete(rule)
        self
      end

      def apply(rule)
        @r = find_rule(rule)
        self
      end

      def to(subject)
        if !@r.nil?
          applied_rule = @r.apply_to(subject)
          @results.push(rule: applied_rule.title, result: applied_rule.result, errors: applied_rule.errors)
          @r = nil
        end
        self
      end

      def reset_results
        @results = []
        self
      end

      def reset_rules
        @rules = []
        @r = nil
        self
      end

      private 

      def find_rule(rule)
        r = @rules.select { |x| x.object_id == rule.object_id }
        r.first unless r.nil? 
      end
    end
  end
end
