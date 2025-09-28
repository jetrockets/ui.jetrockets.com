module FormBuilders
  module Fields
    class CheckBoxField < BaseField
      def initialize(form_builder, method, options = {}, checked_value = "1", unchecked_value = "0")
        super(form_builder, method, options)
        @checked_value = checked_value
        @unchecked_value = unchecked_value
      end

      def render
        label_text = @options.delete(:label)
        hint = @options.delete(:hint)

        @template.content_tag(:div, class: "flex items-start") do
          checkbox_tag + label_and_hint_container(label_text, hint)
        end
      end

      private

      def checkbox_tag
        ActionView::Helpers::FormBuilder.instance_method(:check_box).bind(@form_builder).call(
          @method,
          @options.merge(class: classes),
          @checked_value,
          @unchecked_value
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
        @form_builder.label(@method, label_text, class: "form__label-checkbox")
      end

      def hint_tag(hint)
        @template.content_tag(:p, hint, class: "form__hint")
      end

      def classes
        class_names(
          "form__checkbox",
          { "form__checkbox-errored": errors? }
        )
      end
    end
  end
end
