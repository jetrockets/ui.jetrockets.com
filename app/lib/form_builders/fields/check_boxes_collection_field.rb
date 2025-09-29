module FormBuilders
  module Fields
    class CheckBoxesCollectionField < BaseField
      def initialize(form_builder, method, collection, value_method, text_method, options = {}, html_options = {}, &block)
        super(form_builder, method, options, &block)
        @collection = collection
        @value_method = value_method
        @text_method = text_method
        @html_options = html_options
      end

      def render
        @template.content_tag(:div, class: "form__checkbox_collection") do
          @collection.map do |item|
            value = item.send(@value_method)
            text = item.send(@text_method)
            unique_id = "#{@method}_#{value}".downcase

            @form_builder.check_box("#{@method}[]", checkbox_options(item, unique_id).merge(label: text, id: unique_id), value, "")
          end.join.html_safe
        end
      end

      private

      def checkbox_options(item, unique_id)
        options = @html_options.dup
        options[:id] = unique_id

        if @block
          options.merge!(@block.call(item))
        end

        options
      end
    end
  end
end
