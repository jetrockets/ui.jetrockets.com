module FormBuilders
  module Inputs
    class Label < BaseInput
      def initialize(form_builder, method, text = nil, options = {}, &block)
        super(form_builder, method, options, &block)
        @text = text
        @block = block
      end

      def render
        label_text = determine_label_text
        @options[:class] = label_classes

        @template.label(@form_builder.object_name, @method, label_text, @options, &@block)
      end

      private

      def determine_label_text
        return @text if @text.present?

        default_label = @method.to_s.humanize
        model_name = @object.class.name.underscore

        I18n.t("activerecord.attributes.#{model_name}.#{@method}", default: default_label)
      end

      def label_classes
        class_names(
          "form__label",
          { "form__label-errored": errors_for? },
          @options.delete(:class)
        )
      end
    end
  end
end
