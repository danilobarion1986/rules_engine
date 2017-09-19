require 'date'
require 'pry-byebug'

module RulesEngine
  module Core
    class Rule
      attr_accessor :title, :description, :assertion, :subject
      attr_reader   :created_at

      def initialize(title, description, assertion, subject)
        @created_at = Time.now
        @title = title || 'Rule title'
        @description = description || 'Rule description'
        @assertion = assertion || -> (*params) { nil }
        @subject = subject || Object.new
        @applied = false 
      end

      def metadata
        { 
          id: self.object_id, 
          created_at: @created_at, 
          title: @title, 
          description: @description,
          assertion: @assertion,
          subject: @subject,
          applied: @applied
        }
      end

      def apply
        @assertion.call(@subject)
        @applied = true
      end

      def applied?
        @applied
      end
    end
  end
end

