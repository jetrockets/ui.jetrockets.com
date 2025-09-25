module FormBuilders
  class SimpleFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = %w[text_field password_field color_field search_field telephone_field phone_field date_field time_field datetime_field datetime_local_field month_field week_field url_field email_field number_field range_field].freeze

    INPUT_HELPERS.each do |field_method|
      define_method(field_method) do |method, options = {}, &block|
        begin
          input_class = "FormBuilders::Inputs::#{field_method.classify}Input".constantize
          input_class.new(self, method, options).render
        rescue NameError
          Inputs::TextInput.new(self, method, options, field_method.to_sym).render
        end
      end
    end

    def text_area(method, options = {})
      options[:data] = { controller: "textarea-autogrow" }.merge(options[:data] || {})
      Inputs::TextInput.new(self, method, options, :text_area).render
    end

    def easepick(method, options = {})
      Inputs::EasepickInput.new(self, method, options).render
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      Inputs::SelectInput.new(self, method, choices, options, html_options).render
    end

    def choices(method, choices = nil, options = {}, html_options = {}, &block)
      Inputs::ChoicesInput.new(self, method, choices, options, html_options).render
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      Inputs::CheckBoxInput.new(self, method, options, checked_value, unchecked_value).render
    end

    def toggler(method, options = {}, checked_value = "1", unchecked_value = "0")
      Inputs::TogglerInput.new(self, method, options, checked_value, unchecked_value).render
    end

    def radio_button(method, tag_value, options = {})
      Inputs::RadioButtonInput.new(self, method, tag_value, options).render
    end

    def label(method, text = nil, options = {}, &block)
      Inputs::Label.new(self, method, text, options, &block).render
    end

    def submit(value = nil, options = {})
      Inputs::Submit.new(self, value, options).render
    end
  end
end


# def easepick(method, options = {})
#   options[:data] = {
#     action: "#{options[:data][:action]} focus->easepick#show",
#     controller: "easepick"
#   }.reverse_merge(options[:data] || {})
#   value = options.delete(:value) || @object&.send(method)

#   if value.present?
#     value = I18n.l(value)
#   end

#   text_field(method, options.merge(value: value))
# end

# def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
#   label_text = options.delete(:label)
#   hint = options.delete(:hint)

#   @template.content_tag :div, class: "flex items-start" do
#     @template.concat super(method, options.merge(class: "form__checkbox"), checked_value, unchecked_value)
#     @template.concat @template.content_tag(:div, class: "pl-2") {
#       @template.concat label(method, label_text, class: "form__label-checkbox") unless label_text == false
#       @template.concat @template.content_tag(:p, hint, class: "form__hint") if hint
#       @template.concat inline_errors_for(method)
#     }
#   end
# end

# def toggle(method, options = {}, checked_value = "1", unchecked_value = "0")
#   checked = @object && @object[method.to_sym] || options[:checked]
#   label_text = options.delete(:label) || @object && @object.class.human_attribute_name(method)

#   hint = options.delete(:hint)

#   if hint.is_a?(String)
#     hint_content = hint
#   else
#     hint_content = content_tag(:span, hint[:on], class: "#{"hidden" unless checked}", data: { form_toggle_target: "on_hint" }) +
#     content_tag(:span, hint[:off], class: "#{"hidden" if checked}", data: { form_toggle_target: "off_hint" })
#   end

#   @template.content_tag :label, class: "inline-flex items-start cursor-pointer gap-y-2", data: { controller: "form-toggle" } do
#     @template.concat @template.check_box(@object_name, method, { checked: checked, class: "sr-only peer", data: { action: "change->form-toggle#toggle" } }.merge(options), checked: "true", unchecked: "false")
#     @template.concat @template.content_tag(:div, "", class: "form__toggle")
#     @template.concat @template.content_tag(:div) {
#       @template.concat @template.content_tag(:span, label_text, class: "form__label form__label-toggle")
#       @template.concat @template.content_tag(:p, hint_content, class: "form__hint mt-0") if hint
#       @template.concat inline_errors_for(method)
#     }
#   end
# end

# def radio_button(method, tag_value, options = {})
#   label_text = options.delete(:label)
#   hint = options.delete(:hint)

#   @template.content_tag :div, class: "flex items-start" do
#     @template.concat super(method, tag_value, options.merge(class: "form__radio", id: "#{method}_#{tag_value}"))
#     @template.concat @template.content_tag(:div, class: "pl-2") {
#       @template.concat label("#{method}_#{tag_value}", label_text, class: "form__label-radio")
#       @template.concat @template.content_tag(:p, hint, class: "form__hint") if hint
#     }
#   end
# end

# def group(options = {}, &block)
#   classes = class_names(
#     "form__group",
#     { "form__group-errored": errors_for?(method) },
#     options&.delete(:class)
#   )

#   @template.content_tag(:div, class: classes, **options) do
#     block.call
#   end
# end

# def submit(value = nil, options = {})
#   classes = class_names(
#     "btn",
#     "btn-primary",
#     options.delete(:class)
#   )

#   super(value, options.merge(class: classes))
# end

# private

# def label_classes(options)
#   klass = options.delete(:class)
#   floating = options.delete(:floating) == true
#   class_names(
#     "form__label",
#     { "form__label-floating": [ "form__label-radio", "form__label-checkbox" ].exclude?(klass) && floating },
#     klass
#   )
# end

# def input_classes(method, options)
#   error_key = options.delete(:error_key) || method

#   class_names(
#     "form__input",
#     { "form__input-errored": errors_for?(error_key) },
#     options.delete(:class)
#   )
# end

# def update_choices_data(choices_data, container_id, id)
#   if choices_data[:new_path].present?
#     uri = URI.parse(choices_data[:new_path])
#     existing_params = URI.decode_www_form(uri.query || "")
#     new_params = { container: container_id, target: id }
#     uri.query = URI.encode_www_form(existing_params.to_h.merge(new_params))

#     choices_data[:new_path] = uri.to_s
#   end
# end

# def required?(method)
#   method_without_id = method.to_s.chomp("_id").to_sym
#   object_method = @object.respond_to?(method_without_id) ? method_without_id : method.to_sym
#   return false unless @object&.class.try(:validators_on, object_method)

#   @object && @object.class.validators_on(object_method).any? { |validator| validator.kind == :presence }
# end

# def errors_for?(method)
#   @object&.errors&.any? && @object&.errors[method.to_sym]&.any?
# end

# def inline_errors_for(method)
#   return unless errors_for?(method)

#   content_tag(:p, @object&.errors[method.to_sym]&.first&.capitalize, class: "form__error")
# end
