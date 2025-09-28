module FormBuilders
  module Fields
    class TogglerField < BaseField
      def initialize(form_builder, method, options = {}, checked_value = "1", unchecked_value = "0")
        super(form_builder, method, options)
        @checked_value = checked_value
        @unchecked_value = unchecked_value
      end

      def render
        label_text = @options.delete(:label)

        @template.content_tag(:div, class: "flex items-start") do
          @template.concat hidden_checkbox
          @template.concat toggler_element(label_text)
          @template.concat toggler_label_with_hint(label_text)
        end
      end

      private

      def hidden_checkbox
        ActionView::Helpers::FormBuilder.instance_method(:check_box).bind(@form_builder).call(
          @method,
          {
            checked: @object && @object[@method.to_sym] || @options[:checked],
            class: "sr-only peer"
          }
        )
      end

      def toggler_element(label_text)
        @form_builder.label(@method, label_text, class: "form__toggler")
      end

      def toggler_label_with_hint(label_text)
        @template.content_tag(:div, class: "pt-0.5 pl-3") do
          @template.concat @form_builder.label(@method, label_text) unless label_text == false
          @template.concat @template.content_tag(:p, @options[:hint], class: "form__hint mt-0") if @options[:hint]
        end
      end
    end
  end
end
