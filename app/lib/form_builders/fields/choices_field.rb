module FormBuilders
  module Fields
    class ChoicesField < BaseField
      def initialize(form_builder, method, choices = nil, select_options = {}, options = {})
        super(form_builder, method, options)
        @choices = choices
        @select_options = select_options
      end

      def render
        @template.content_tag(:div, id: @container_id, class: form__choices_classes, data: { controller: "choices" }) do
          @select_options[:required] = required?
          @options[:class] = field_classes(@options[:class])
          @options[:data] = { choices_target: "select" }.merge(@options[:data] || {})

          prepare_new_path_params

          ActionView::Helpers::FormBuilder.instance_method(:select).bind(@form_builder).call(@method, @choices, @select_options, @options)
        end
      end

      private

      def prepare_new_path_params
        return unless @options[:data][:new].present?

        @container_id = @form_builder.field_id("#{@method}_container")
        @id = @form_builder.field_id(@method)

        uri = URI.parse(@options[:data][:new])
        existing_params = URI.decode_www_form(uri.query || "")
        new_params = { container: @container_id, target: @id }
        uri.query = URI.encode_www_form(existing_params.to_h.merge(new_params))

        @options[:data][:new] = uri.to_s
      end

      def form__choices_classes
        size = @options[:size] || :md

        class_names(
          "form__choices",
          "form__choices-sm": size == :sm,
          "form__choices-lg": size == :lg,
          "form__choices-errored": errors?
        )
      end
    end
  end
end
