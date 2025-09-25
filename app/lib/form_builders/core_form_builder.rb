module FormBuilders
  class CoreFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    INPUT_HELPERS = %w[text_field password_field color_field search_field telephone_field phone_field date_field time_field datetime_field datetime_local_field month_field week_field url_field email_field number_field range_field].freeze

    INPUT_HELPERS.each do |field_method|
      define_method(field_method) do |method, options = {}, &block|
        begin
          field_class = "FormBuilders::Fields::#{field_method.classify}Field".constantize
          field_class.new(self, method, options).render
        rescue NameError
          Fields::TextField.new(self, method, options, field_method.to_sym).render
        end
      end
    end

    def text_area(method, options = {})
      options[:data] = { controller: "textarea-autogrow" }.merge(options[:data] || {})
      Fields::TextField.new(self, method, options, :text_area).render
    end

    def easepick(method, options = {})
      Fields::EasepickField.new(self, method, options).render
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      Fields::SelectField.new(self, method, choices, options, html_options).render
    end

    def choices(method, choices = nil, options = {}, html_options = {}, &block)
      Fields::ChoicesField.new(self, method, choices, options, html_options).render
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      Fields::CheckBoxField.new(self, method, options, checked_value, unchecked_value).render
    end

    def toggler(method, options = {}, checked_value = "1", unchecked_value = "0")
      Fields::TogglerField.new(self, method, options, checked_value, unchecked_value).render
    end

    def radio_button(method, tag_value, options = {})
      Fields::RadioButtonField.new(self, method, tag_value, options).render
    end

    def label(method, text = nil, options = {}, &block)
      Fields::Label.new(self, method, text, options, &block).render
    end

    def submit(value = nil, options = {})
      Fields::Submit.new(self, value, options).render
    end
  end
end
