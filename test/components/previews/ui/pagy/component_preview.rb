class Ui::Pagy::ComponentPreview < ViewComponent::Preview
  def with_default
    pagy = Pagy.new(count: 100, page: 1)

    render(Ui::Pagy::Component.new(pagy:))
  end
end
