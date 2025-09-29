module FormBuilders
  module Fields
    class Submit < Base
      def initialize(form_builder, value = nil, options = {})
        super(form_builder, value, options)
        @value = value
      end

      def render
        classes = class_names(
          "btn",
          "btn-primary",
          @options.delete(:class)
        )

        @template.submit_tag(@value, class: classes, **@options)
      end
    end
  end
end
