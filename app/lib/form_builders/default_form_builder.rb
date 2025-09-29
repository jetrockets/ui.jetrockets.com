module FormBuilders
  class DefaultFormBuilder < CoreFormBuilder
    INPUT_HELPERS.each do |field_method|
      define_method(field_method) do |method, options = {}, &block|
        create_form_group(method, options) do
          super(method, extract_field_options(options))
        end
      end
    end

    def text_area(method, options = {})
      create_form_group(method, options) do
        super(method, extract_field_options(options))
      end
    end

    def easepick(method, options = {})
      create_form_group(method, options) do
        super(method, extract_field_options(options))
      end
    end

    def select(method, choices = nil, options = {}, html_options = {})
      create_form_group(method, html_options) do
        super(method, choices, extract_field_options(options), html_options)
      end
    end

    def choices(method, choices = nil, options = {}, html_options = {})
      create_form_group(method, html_options) do
        super(method, choices, extract_field_options(options), html_options)
      end
    end

    # Group container for form elements
    def group(options = {}, &block)
      Fields::Group.new(self, nil, options, &block).render
    end

    private

    def create_form_group(method, options, &block)
      group_options = extract_group_options(options)

      Fields::Group.new(self, method, group_options) do
        # Label only if not false
        unless options[:label] == false
          label_text = options.delete(:label)
          @template.concat label(method, label_text)
        end

        # field
        @template.concat block.call

        # Hint
        if options[:hint]
          @template.concat hint_tag(options.delete(:hint))
        end

        # Errors
        custom_error = options[:error]
        @template.concat inline_errors_for(method, custom_error)
      end.render
    end

    def extract_group_options(options)
      options.delete(:group_html) || {}
    end

    def extract_field_options(options)
      # Remove group-specific options from field, but keep :error for BaseField CSS classes
      options.except(:label, :hint, :group_html)
    end

    def hint_tag(hint)
      @template.content_tag(:p, hint, class: "form__hint")
    end
  end
end
