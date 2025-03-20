class Ui::Breadcrumb::ComponentPreview < ViewComponent::Preview
  def with_ui_page
    render(Ui::Breadcrumb::Component.new(:ui))
  end
end
