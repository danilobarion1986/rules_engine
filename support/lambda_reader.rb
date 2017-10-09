
module RulesEngine
  module Support
    class LambdaReader
      class << self
        def lambda2source(lambda_obj)
          lambda_obj_location_array = lambda_obj.source_location
          @file_name = lambda_obj_location_array.first
          @line_number = lambda_obj_location_array.last
          @lambda_code_line = extract_lambda_code_line
          match_lambda_syntax
        end

        private

        def extract_lambda_code_line
          IO.readlines(@file_name)[@line_number - 1]
        end

        def match_lambda_syntax
          m = classic_syntax_matcher || dash_rocket_syntax_matcher
          m[0] unless m.nil?
        end

        def classic_syntax_matcher
          /lambda ?{ ?\|.*\|.*}/m.match(@lambda_code_line)
        end

        def dash_rocket_syntax_matcher
          /-> ?\(.*\) ?{.*}/m.match(@lambda_code_line)
        end
      end
    end
  end
end
