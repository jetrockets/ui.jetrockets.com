module FormBuilders
  module Inputs
    class EasepickInput < BaseInput
      def initialize(form_builder, method, options = {})
        super(form_builder, method, options)
      end

      def render
        @value = @options.delete(:value) || @object&.send(@method)
        @options[:value] = @value.present? ? I18n.l(@value) : nil

        @options[:data] = {
          action: "#{@options.dig(:data, :action)} focus->easepick#show",
          controller: "easepick"
        }.merge(@options[:data] || {})

        @form_builder.text_field(@method, @options)
      end
    end
  end
end
