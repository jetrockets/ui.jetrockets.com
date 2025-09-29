module FormBuilders
  module Fields
    class BaseField
      include ActionView::Helpers::TagHelper

      def initialize(form_builder, method, options = {}, &block)
        @form_builder = form_builder
        @method = method
        @options = options.symbolize_keys
        @object = form_builder.object
        @template = form_builder.instance_variable_get(:@template)
        @block = block
        @custom_error = @options.delete(:error)
        @size = @options.delete(:size)
      end

      protected

      def errors?
        @custom_error || (@object&.errors&.any? && @object&.errors[@method.to_sym]&.any?)
      end

      def required?
        return @options[:required] if @options.key?(:required)

        @method_without_id = @method.to_s.chomp("_id").to_sym
        @validation_method = @object.respond_to?(@method_without_id) ? @method_without_id : @method.to_sym
        return false unless @object&.class.try(:validators_on, @validation_method)

        @object.class.validators_on(@validation_method).any? { |v| v.kind == :presence }
      end

      def field_classes(additional_classes = nil)
        class_names(
          "form__field",
          additional_classes,
          { "form__field-sm": @size == :sm },
          { "form__field-lg": @size == :lg },
          { "form__field-errored": errors? },
          @options.delete(:class),
        )
      end

      def label_classes
        class_names(
          "form__label",
          { "form__label-disabled": @options[:disabled] },
          { "form__label-sm": @size == :sm },
          { "form__label-lg": @size == :lg },
          { "form__label-errored": errors? },
          @options.delete(:class)
        )
      end
    end
  end
end
