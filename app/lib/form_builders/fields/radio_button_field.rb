module FormBuilders
  module Fields
    class RadioButtonField < BaseField
      def initialize(form_builder, method, tag_value, options = {})
        super(form_builder, method, options)
        @tag_value = tag_value
      end

      def render
        label_text = @options.delete(:label)
        hint = @options.delete(:hint)

        @template.content_tag(:div, class: "inline-flex items-start") do
          radio_tag + label_and_hint_container(label_text, hint)
        end
      end

      private

      def radio_tag
        ActionView::Helpers::FormBuilder.instance_method(:radio_button).bind(@form_builder).call(
          @method,
          @tag_value,
          @options.merge(
            class: classes
          )
        )
      end

      def label_and_hint_container(label_text, hint)
        @template.content_tag(:div, class: "pl-2") do
          @template.concat label_tag(label_text) unless label_text == false
          @template.concat hint_tag(hint) if hint
          @template.concat @form_builder.inline_errors_for(@method, @custom_error) if errors?
        end
      end

      def label_tag(label_text)
        @form_builder.label("#{@method}_#{@tag_value}", label_text, class: "form__label-radio")
      end

      def hint_tag(hint)
        @template.content_tag(:p, hint, class: "form__hint")
      end

       def classes
        class_names(
          "form__radio",
          "form__radio-errored": errors?
        )
      end
    end
  end
end
