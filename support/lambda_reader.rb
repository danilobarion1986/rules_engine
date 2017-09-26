
module RulesEngine
  module Support
    class LambdaReader
      def self.lambda2source(lambda_obj)
        lambda_obj_location_array = lambda_obj.source_location
        @file_name = lambda_obj_location_array.first
        @line_number = lambda_obj_location_array.last
        @lambda_code_line = extract_lambda_code_line
        lambda_code_string = match_lambda_syntax
      end

      private

      def self.extract_lambda_code_line
        IO.readlines(@file_name)[@line_number - 1]
      end

      def self.match_lambda_syntax
        m = classic_syntax_matcher || dash_rocket_syntax_matcher
        m[0] unless m.nil?
      end

      def self.classic_syntax_matcher
        /lambda ?{ ?\|.*\|.*}/m.match(@lambda_code_line)
      end

      def self.dash_rocket_syntax_matcher
        /-> ?\(.*\) ?{.*}/m.match(@lambda_code_line)
      end
    end
  end
end
