module FormBuilders
  module Fields
    class GroupField < BaseField
      def initialize(form_builder, method = nil, options = {}, &block)
        super(form_builder, method, options, &block)
      end

      def render
        @template.content_tag(:div, class: build_group_classes, **@options) do
          @block ? @block.call : ""
        end
      end

      private

      def build_group_classes
        class_names(
          "form__group",
          { "form__group-errored": @method && errors_for?(@method) },
          @options.delete(:class)
        )
      end
    end
  end
end
