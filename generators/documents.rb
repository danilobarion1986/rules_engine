require 'pry-byebug'
require_relative '../support/lambda_reader'

module RulesEngine
  module Generators
    class Documents
      attr_reader :ruleset, :content

      def initialize(ruleset)
        @ruleset = ruleset
        @content = ''
      end

      def create_docs(filepath = File.join('.', 'rulesets_docs'), filename = @ruleset.title.to_s)
        read_content_from_rules
        write_file(filepath, filename)
        puts "Docs created for '#{@ruleset.title}' ruleset!"
      end

      private

      def read_content_from_rules
        content << create_doc_header
        return if @ruleset.rules.empty?
        @ruleset.rules.each do |rule|
          content << create_doc_block_for(rule)
        end
      end

      def write_file(filepath, filename)
        Dir.mkdir(filepath) unless Dir.exist?(filepath)
        file = File.new(File.join(filepath, "#{filename.tr(' ', '_').downcase}.md"), 'w+')
        file.write(@content)
        file.close
      end

      def create_doc_header
        header = ''
        header << "##{@ruleset.title}\n\n"
        header << "#{@ruleset.description}\n\n"
      end

      def create_doc_block_for(rule)
        rule_block = create_title_description_doc_block(rule)
        rule_block << create_metadata_doc_block(rule)
        rule_block << create_source_code_info_doc_block(rule)
      end

      def create_title_description_doc_block(rule)
        rule_block = "###{rule.title}\n\n#{rule.description}\n\n"
        rule_block << "This rule is applied to class _#{rule.subject_class}_.\n\n"
        rule_block
      end

      def create_metadata_doc_block(rule)
        rule_block = "Rule assertion:\n\n```\n"
        rule_block << "#{RulesEngine::Support::LambdaReader.lambda2source(rule.assertion)}\n```\n\n"
        rule_block << "Rule created on:\n"
        rule_block
      end

      def create_source_code_info_doc_block(rule)
        rule_block = "- File: #{rule.assertion.source_location.first}\n"
        rule_block << "- Line: #{rule.assertion.source_location.last}\n"
        rule_block << "\n\n"
        rule_block
      end
    end
  end
end
