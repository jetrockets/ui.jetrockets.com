module FormBuilders
  class DefaultFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = field_helpers - [ :check_box, :radio_button, :fields_for, :fields, :hidden_field, :file_field, :email ]

    def group(options = {}, &block)
      @template.content_tag :div, class: "form__group", **options do
        block.call
      end
    end

    INPUT_HELPERS.each do |field_method|
      define_method("#{field_method}") do |method, options = {}|
        input_classes = class_names(
          "form__input",
          { "form__input-errored": @object&.errors&.any },
          options.delete(:class)
        )

        unless options[:label] == false
          form_group(method, options) do
            field_label(method, options) + super(method, options.reverse_merge(class: input_classes))
          end
        else
          super(method, options.reverse_merge(class: input_classes))
        end
      end
    end

    def label(method, text = nil, options = {})
      classes = class_names(
        "form__label",
        options.delete(:class)
      )

      super(method, text, options.merge({ class: classes }))
    end

    def form_group(*args, &block)
      # **options.except(:add_control_col_class, :append, :control_col, :floating, :help, :icon, :id, :input_group_class, :label, :label_col, :layout, :prepend

      @template.content_tag(:div, class: "form__group") do
        block.call
      end
    end

    private

    def field_label(method, options)
      label(method, options[:label])
    end
  end
end
