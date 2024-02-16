module FormBuilders
  class DefaultFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = %w[text_field password_field text_area color_field search_field telephone_field phone_field date_field time_field datetime_field datetime_local_field month_field week_field url_field email_field number_field range_field]

    INPUT_HELPERS.each do |field_method|
      define_method("#{field_method}") do |method, options = {}|
        input_classes = class_names(
          "form__input",
          { "form__input-errored": @object&.errors&.any },
          options.delete(:class)
        )

        if options[:simple] == true
          super(method, options.reverse_merge(class: input_classes))
        else
          group_options = options.delete(:group) || {}
          group(group_options) do
            label_options = options.delete(:label) || {}
            label(method, label_options) + super(method, options.reverse_merge(class: input_classes))
          end
        end
      end
    end

    def label(method, options = {})
      text = label_text(options)

      classes = class_names(
        "form__label",
        options.is_a?(Hash) && options.delete(:class)
      )

      if options.is_a?(Hash)
        super(method, text, options.merge({ class: classes }))
      else
        super(method, text, { class: classes })
      end
    end

    def group(options = {}, &block)
      classes = class_names(
        "form__group",
        options&.delete(:class)
      )

      @template.content_tag(:div, class: classes, **options) do
        block.call
      end
    end

    private

    def label_text(options)
      text = options[:text] if options.is_a?(Hash)
      text ||= options if options.is_a?(String)
      text
      # || @object&.class&.human_attribute_name(method)
    end
  end
end
