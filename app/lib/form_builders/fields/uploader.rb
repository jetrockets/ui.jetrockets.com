module FormBuilders
  module Fields
    class Uploader < Base
      def initialize(form_builder, method, options = {})
        super(form_builder, method, options)
        @multiple = @options.delete(:multiple) || false
      end

      def render
        @form_builder.multipart = true

        @template.render(FormBuilders::Uploader::Component.new(**component_options))
      end

      private

      def component_options
        {
          name: @form_builder.field_name(@method, multiple: @multiple),
          id: @form_builder.field_id(@method),
          multiple: @multiple,
          size: @size,
          required: required?,
          errored: errors?.present?
        }.merge(@options)
      end
    end
  end
end
