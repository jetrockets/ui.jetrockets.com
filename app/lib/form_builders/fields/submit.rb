module FormBuilders
  module Fields
    class Submit < Base
      def initialize(form_builder, value = nil, options = {})
        super(form_builder, value, options)
        @value = value
      end

      def render
        @template.render(Ui::Btn::Component.new(type: "submit", **@options)) { @value }
      end
    end
  end
end
