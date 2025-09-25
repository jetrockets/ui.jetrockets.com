module FormBuilders
  module Inputs
    class BaseInput
      include ActionView::Helpers::TagHelper

      def initialize(form_builder, method, options = {})
        @form_builder = form_builder
        @method = method
        @options = options
        @object = form_builder.object
        @template = form_builder.instance_variable_get(:@template)
      end

      protected

      def errors_for?(method = @method)
        @object&.errors&.any? && @object&.errors[method.to_sym]&.any?
      end

      def required?
        return @options[:required] if @options.key?(:required)

        @method_without_id = @method.to_s.chomp("_id").to_sym
        @validation_method = @object.respond_to?(@method_without_id) ? @method_without_id : @method.to_sym
        return false unless @object&.class.try(:validators_on, @validation_method)

        @object.class.validators_on(@validation_method).any? { |v| v.kind == :presence }
      end

      def input_classes(additional_classes = nil)
        class_names(
          "form__input",
          { "form__input-errored": errors_for? },
          additional_classes,
          @options.delete(:class)
        )
      end
    end
  end
end
