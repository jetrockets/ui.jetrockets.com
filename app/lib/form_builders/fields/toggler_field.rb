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

        @template.content_tag(:div, class: "flex items-center") do
          @template.concat hidden_checkbox
          @template.concat toggler_container(label_text)
          @template.concat @form_builder.label(@method, label_text, class: "pl-2") unless label_text == false
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

      def toggler_container(label_text)
        @form_builder.label(@method, label_text, class: "form__toggler")
      end
    end
  end
end
