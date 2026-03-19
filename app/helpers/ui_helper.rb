module UiHelper
  def ui
    @ui_builder ||= UiBuilder.new(self)
  end

  class UiBuilder
    def initialize(view_context)
      @view = view_context
    end

    def method_missing(name, *args, **kwargs, &block)
      component_class = resolve_component(name)
      content = args.shift if args.first.is_a?(String)
      instance = component_class.new(*args, **kwargs)
      content ? @view.render(instance) { content } : @view.render(instance, &block)
    end

    private

    def resolve_component(name)
      # turbo_confirm -> try Ui::TurboConfirm::Component first, then Ui::Turbo::ConfirmComponent
      parts = name.to_s.split("_")
      "Ui::#{name.to_s.camelize}::Component".safe_constantize ||
        "Ui::#{parts.first.camelize}::#{parts.drop(1).map(&:camelize).join}Component".constantize
    end
  end
end
