require 'date'
require 'pry-byebug'

module RulesEngine
  module Core
    class Rule
      attr_accessor :title, :description, :subject
      attr_reader   :created_at, :assertion, :result, :errors

      def initialize(title, description, assertion, subject)
        @created_at = Time.now
        @title = title || 'Rule title'
        @description = description || 'Rule description'
        @assertion = assertion || -> (*params) { nil }
        @subject = subject || Object.new
        @applied = false
        @applied_at = nil
        @result = nil
        @errors = []
      end

      def assertion=(lambda)
        lambda.(@subject)
        @assertion = lambda
      rescue => e
        @errors.push(e)
        puts e.message
      end

      def metadata
        { id: self.object_id, created_at: @created_at, title: @title, description: @description,
          assertion: @assertion, subject: @subject, applied: @applied, result: @result,
          errors: @errors }
      end

      def apply
        @applied_at = Time.now
        @result = @assertion.call(@subject)
        @applied = true
        self
      rescue
        @applied_at = nil
        @applied = false
        @result = nil
      end

      def applied?
        @applied
      end
    end
  end
end

