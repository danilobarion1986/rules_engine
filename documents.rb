require 'pry-byebug'

module RulesEngine
  module Generators
    class Documents
      attr_reader :ruleset, :body

      def initialize(ruleset)
        @ruleset = ruleset
        @body = ""
      end
      
      def create_docs(type: :markdown)
        read_rules
        write_file
        puts "Docs created for #{@ruleset.title} ruleset!"
        puts @body
      end

      def read_rules
        body << create_doc_header
        @ruleset.rules.each do |rule|
          body << create_doc_block_for(rule)
        end unless @ruleset.rules.empty?
      end

      def write_file
        file = File.new('doc.md', 'w+')
        file.write(@body)
        file.close
      end

      def create_doc_header
        header = ''
        header << "##{@ruleset.title}\n\n"
        header << "#{@ruleset.description}\n\n"
      end

      def create_doc_block_for(rule)
        rule_block = ''
        rule_block << "###{rule.title}\n\n"
        rule_block << "#{rule.description}\n\n"
        rule_block << "This rule is applied to class _#{rule.subject_class}_.\n\n"
        rule_block << "Rule assertion:\n\n"
        rule_block << "```\n"
        rule_block << "#{rule.assertion}\n"
        rule_block << "```\n\n"
        rule_block << "Rule created on:\n"
        rule_block << "- File: #{rule.assertion.source_location.first}\n"
        rule_block << "- Line: #{rule.assertion.source_location.last}\n"
        rule_block << "\n\n"
      end
    end
  end
end