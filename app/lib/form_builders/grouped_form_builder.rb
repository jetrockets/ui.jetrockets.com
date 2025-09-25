module FormBuilders
  class GroupedFormBuilder < SimpleFormBuilder
    # Переопределяем все методы инпутов, чтобы они автоматически создавали группы
    INPUT_HELPERS.each do |field_method|
      define_method(field_method) do |method, options = {}, &block|
        create_form_group(method, options) do
          super(method, extract_input_options(options))
        end
      end
    end

    def text_area(method, options = {})
      create_form_group(method, options) do
        super(method, extract_input_options(options))
      end
    end

    def select(method, choices = nil, options = {}, html_options = {})
      create_form_group(method, options) do
        super(method, choices, extract_input_options(options), html_options)
      end
    end

    def choices(method, choices = nil, options = {}, html_options = {})
      create_form_group(method, options) do
        super(method, choices, extract_input_options(options), html_options)
      end
    end

    def easepick(method, options = {})
      create_form_group(method, options) do
        super(method, extract_input_options(options))
      end
    end

    # Для check_box, radio_button, toggle не создаем группу, так как у них своя разметка
    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      super(method, options, checked_value, unchecked_value)
    end

    def toggler(method, options = {}, checked_value = "1", unchecked_value = "0")
      super(method, options, checked_value, unchecked_value)
    end

    def radio_button(method, tag_value, options = {})
      super(method, tag_value, options)
    end

    # Группа без инпута - просто контейнер
    def group(options = {}, &block)
      Inputs::GroupInput.new(self, nil, options, &block).render
    end

    private

    def create_form_group(method, options, &block)
      group_options = extract_group_options(options)

      Inputs::GroupInput.new(self, method, group_options) do
        content = ""

        # Лейбл (если не отключен)
        unless options[:label] == false
          label_text = options.delete(:label)
          content += label(method, label_text)
        end

        # Инпут
        content += block.call

        # Подсказка
        if options[:hint]
          content += hint_tag(options.delete(:hint))
        end

        # Ошибки
        content += inline_errors_for(method)

        content.html_safe
      end.render
    end

    def extract_group_options(options)
      {
        class: options.delete(:group_class),
        id: options.delete(:group_id),
        data: options.delete(:group_data)
      }.compact
    end

    def extract_input_options(options)
      # Убираем group-специфичные опции из инпута
      options.except(:label, :hint, :group_class, :group_id, :group_data)
    end

    def hint_tag(hint)
      @template.content_tag(:p, hint, class: "form__hint")
    end

    def inline_errors_for(method)
      return "" unless errors_for?(method)
      @template.content_tag(:p, @object&.errors[method.to_sym]&.first&.capitalize, class: "form__error")
    end

    def errors_for?(method)
      @object&.errors&.any? && @object&.errors[method.to_sym]&.any?
    end
  end
end
