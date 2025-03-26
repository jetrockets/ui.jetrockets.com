class Ui::Accordion::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param id
  # @param content

  def default(title: "Titile", id: "id", content: "This is the body of the accordion. You can put any content here.")
    render(Ui::Accordion::Component.new) do |accordion|
      accordion.with_item(title: title, id: id) do
        content_tag(:p, content)
      end
    end
  end
end
