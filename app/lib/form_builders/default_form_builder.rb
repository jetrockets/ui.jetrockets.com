module FormBuilders
  class DefaultFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = %w[text_field password_field text_area color_field search_field telephone_field phone_field date_field time_field datetime_field datetime_local_field month_field week_field url_field email_field number_field range_field]

    INPUT_HELPERS.each do |field_method|
      define_method("#{field_method}") do |method, options = {}|
        input_classes = class_names(
          "form__input",
          { "form__input-errored": @object&.errors&.any? },
          options.delete(:class)
        )

        super(method, options.reverse_merge(class: input_classes))
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

    def check_box(method, options = {})
      label_text = options.delete(:label)
      hint = options.delete(:hint)

      @template.content_tag :div, class: "flex items-start" do
        @template.concat super(method, options.merge(class: "form__checkbox"))
        @template.concat @template.content_tag(:div, class: "pl-2") {
          @template.concat label(method, label_text, class: "form__label-checkbox")
          @template.concat @template.content_tag(:p, hint, class: "form__hint") if hint
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

    #   # def radio_button(method, value, options = {})
    #   #   input_classes = class_names(
    #   #     "form__radio",
    #   #     { "form__radio-errored": @object&.errors&.any },
    #   #     options.delete(:class)
    #   #   )

    #   #   if options[:simple] == true
    #   #     super(method, options.reverse_merge(class: input_classes))
    #   #   else
    #   #     group_options = options.delete(:group) || {}
    #   #     group(group_options) do
    #   #       label_options = options.delete(:label) || {}
    #   #       @template.content_tag(:div, class: "flex items-start") do
    #   #         @template.content_tag(:div, class: "leading-none") do
    #   #           super(method, options.reverse_merge(class: input_classes))
    #   #         end +
    #   #         @template.content_tag(:div, class: "pl-2") do
    #   #           label(method, label_options.merge({ class: "form__label-radio" })) +
    #   #           @template.content_tag(:p, class: "form__hint") do
    #   #             options[:hint]
    #   #           end
    #   #         end
    #   #       end
    #   #     end
    #   #   end
    #   # end


    #   def label(method, options = {})
    #     text = label_text(options)

    #     classes = class_names(
    #       "form__label",
    #       options.is_a?(Hash) && options.delete(:class)
    #     )

    #     if options.is_a?(Hash)
    #       super(method, text, options.merge({ class: classes }))
    #     else
    #       super(method, text, { class: classes })
    #     end
    #   end

    #   def group(options = {}, &block)
    #     classes = class_names(
    #       "form__group",
    #       options&.delete(:class)
    #     )

    #     @template.content_tag(:div, class: classes, **options) do
    #       block.call
    #     end
    #   end

    #   private

    #   def label_text(options)
    #     text = options[:text] if options.is_a?(Hash)
    #     text ||= options if options.is_a?(String)
    #     text
    #     # || @object&.class&.human_attribute_name(method)
    #   end
  end
end
