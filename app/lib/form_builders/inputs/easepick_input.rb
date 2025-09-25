module FormBuilders
  module Inputs
    class EasepickInput < BaseInput
      def render
        setup_easepick_options
        super
      end

      private

      def setup_easepick_options
        @options[:data] = {
          action: "#{@options.dig(:data, :action)} focus->easepick#show",
          controller: "easepick"
        }.merge(@options[:data] || {})

        value = @options.delete(:value) || @object&.send(@method)
        @options[:value] = value.present? ? I18n.l(value) : nil
      end
    end
  end
end
