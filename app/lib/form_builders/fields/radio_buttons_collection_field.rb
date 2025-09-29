module FormBuilders
  module Fields
    class RadioButtonsCollectionField < BaseField
      def initialize(form_builder, method, collection, value_method, text_method, options = {}, html_options = {}, &block)
        super(form_builder, method, options, &block)
        @collection = collection
        @value_method = value_method
        @text_method = text_method
        @html_options = html_options
      end

      def render
        @template.content_tag(:div, class: "form__radio_collection") do
          @collection.map do |item|
            value = item.send(@value_method)
            text = item.send(@text_method)

            @form_builder.radio_button(@method, value, radio_button_options(item).merge(label: text))
          end.join.html_safe
        end
      end

      private

      def radio_button_options(item)
        options = @html_options.dup

        if @block
          options.merge!(@block.call(item))
        end

        options
      end
    end
  end
end
