module FormBuilders
  module Fields
    class ChoicesField < BaseField
      def initialize(form_builder, method, choices = nil, select_options = {}, html_options = {})
        super(form_builder, method, html_options)
        @choices = choices
        @select_options = select_options
        @html_options = html_options
      end

      def render
        @select_options[:required] = required?
        @html_options[:class] = field_classes(@html_options[:class])
        @html_options[:data] = { choices_target: "select" }.merge(@html_options[:data] || {})

        prepare_new_path_params

        @template.content_tag(:div, id: @container_id, class: form__choices_classes, data: { controller: "choices" }) do
          ActionView::Helpers::FormBuilder.instance_method(:select).bind(@form_builder).call(@method, @choices, @select_options, @html_options)
        end
      end

      private

      def prepare_new_path_params
        return unless @html_options[:data][:new].present?

        @container_id = @form_builder.field_id("#{@method}_container")
        @id = @form_builder.field_id(@method)

        uri = URI.parse(@html_options[:data][:new])
        existing_params = URI.decode_www_form(uri.query || "")
        new_params = { container: @container_id, target: @id }
        uri.query = URI.encode_www_form(existing_params.to_h.merge(new_params))

        @html_options[:data][:new] = uri.to_s
      end

      def form__choices_classes
        class_names(
          "form__choices",
          "form__choices-errored": errors_for?
        )
      end
    end
  end
end
