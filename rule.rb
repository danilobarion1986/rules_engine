require 'date'
require 'pry-byebug'

module RulesEngine
  module Core
    class Rule
      attr_accessor :reapplicable
      attr_reader   :title, :description, :subject_class, :assertion,
                    :result, :errors, :created_at, :applied_at

      def initialize(title, description, assertion, subject_class)
        @created_at = Time.now
        @title = title
        @description = description
        @assertion = assertion || ->(*_params) { nil }
        @subject_class = subject_class || Object.new
        @applied = false
        @reapplicable = true
        @applied_at = nil
        @result = nil
        @errors = nil
      end

      def metadata
        { id: object_id, created_at: @created_at, title: @title, description: @description,
          assertion: @assertion, subject_class: @subject_class, applied: @applied, reapplicable: @reapplicable,
          applied_at: @applied_at, result: @result, errors: @errors }
      end

      def apply_to(subject)
        reset_result_if_applied

        if subject_is_of_expected_class(subject)
          @applied_at = Time.now
          @applied = true
          @result = @assertion.call(subject)
        else
          add_error(ArgumentError,
                    "The rule expects an object of #{@subject_class} class, but #{subject.class} was given.")
        end

        self
      end

      def applied?
        @applied
      end

      def reapplicable?
        @reapplicable
      end

      private

      def subject_is_of_expected_class(subject)
        subject.class == @subject_class
      end

      def reset_result_if_applied
        if applied? && !reapplicable?
          raise StandardError, 'This rule cannot be reapplied!'
        end
        @result = nil if applied?
      end

      def add_error(type, description)
        @errors.push(error_type: type, error_description: description)
      end
    end
  end
end
