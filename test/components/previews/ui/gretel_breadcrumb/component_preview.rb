class Ui::GretelBreadcrumb::ComponentPreview < ViewComponent::Preview
  def with_ui_page
    render(Ui::GretelBreadcrumb::Component.new(:ui))
  end
end
