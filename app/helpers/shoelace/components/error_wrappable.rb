# frozen_string_literal: true

module Shoelace
  module Components
    module ErrorWrappable
      def error_wrapping(html_tag)
        if object_has_errors? && field_error_proc
          @template_object.instance_exec(html_tag, self, &field_error_proc)
        else
          html_tag
        end
      end

      private

      def field_error_proc
        Shoelace::SlFormBuilder.field_error_proc
      end
    end
  end
end
