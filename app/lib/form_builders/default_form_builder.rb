module FormBuilders
  class DefaultFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = %w[text_field password_field text_area color_field search_field telephone_field phone_field date_field time_field datetime_field datetime_local_field month_field week_field url_field email_field number_field range_field]

    INPUT_HELPERS.each do |field_method|
      define_method("#{field_method}") do |method, options = {}|
        input_classes = class_names(
          "form__input",
          { "form__input-errored": errors_for?(method) },
          options.delete(:class)
        )

        super(method, options.reverse_merge(class: input_classes)) + inline_errors_for(method)
      end
    end

    def label(method, text = nil, options = {}, &block)
      input_classes = class_names(
        "form__label",
        options.delete(:class)
      )

      options[:class] = input_classes
      super
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      input_classes = class_names(
        "form__input",
        { "form__input-errored": @object&.errors&.any? },
        html_options.delete(:class)
      )

      html_options[:class] = input_classes
      super
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      label_text = options.delete(:label)
      hint = options.delete(:hint)

      @template.content_tag :div, class: "flex items-start" do
        @template.concat super(method, options.merge(class: "form__checkbox"), checked_value, unchecked_value)
        @template.concat @template.content_tag(:div, class: "pl-2") {
          @template.concat label(method, label_text, class: "form__label-checkbox")
          @template.concat @template.content_tag(:p, hint, class: "form__hint") if hint
          @template.concat inline_errors_for(method)
        }
      end
    end

    def toggle(method, options = {}, checked_value = "1", unchecked_value = "0")
      checked = @object && @object[method.to_sym] || options[:checked]
      label_text = options.delete(:label) || @object && @object.class.human_attribute_name(method)

      hint = options.delete(:hint)

      if hint.is_a?(String)
        hint_content = hint
      else
        hint_content = content_tag(:span, hint[:on], class: "#{"hidden" unless checked}", data: { form_toggle_target: "on_hint" }) +
        content_tag(:span, hint[:off], class: "#{"hidden" if checked}", data: { form_toggle_target: "off_hint" })
      end

      @template.content_tag :label, class: "inline-flex items-start cursor-pointer gap-y-2", data: { controller: "form-toggle" } do
        @template.concat @template.check_box(@object_name, method, { checked: checked, class: "sr-only peer", data: { action: "change->form-toggle#toggle" } }.merge(options), checked: "true", unchecked: "false")
        @template.concat @template.content_tag(:div, "", class: "form__toggle")
        @template.concat @template.content_tag(:div) {
          @template.concat @template.content_tag(:span, label_text, class: "form__label form__label-toggle")
          @template.concat @template.content_tag(:p, hint_content, class: "form__hint mt-0") if hint
          @template.concat inline_errors_for(method)
        }
      end
    end

    def radio_button(method, tag_value, options = {})
      label_text = options.delete(:label)
      hint = options.delete(:hint)

      @template.content_tag :div, class: "flex items-start" do
        @template.concat super(method, tag_value, options.merge(class: "form__radio", id: "#{method}_#{tag_value}"))
        @template.concat @template.content_tag(:div, class: "pl-2") {
          @template.concat label("#{method}_#{tag_value}", label_text, class: "form__label-radio")
          @template.concat @template.content_tag(:p, hint, class: "form__hint") if hint
        }
      end
    end

    def group(options = {}, &block)
      classes = class_names(
        "form__group",
        { "form__group-errored": errors_for?(method) },
        options&.delete(:class)
      )

      @template.content_tag(:div, class: classes, **options) do
        block.call
      end
    end

    def submit(value = nil, options = {})
      classes = class_names(
        "btn",
        "btn-primary",
        options.delete(:class)
      )

      super(value, options.merge(class: classes))
    end

    private

    def errors_for?(method)
      @object&.errors&.any? && @object&.errors[method.to_sym]&.any?
    end

    def inline_errors_for(method)
      return unless errors_for?(method)

      content_tag(:p, @object&.errors[method.to_sym]&.first&.capitalize, class: "form__error")
    end
  end
end
