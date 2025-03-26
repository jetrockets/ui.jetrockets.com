class Ui::Accordion::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param id
  # @param content
  # @param activeClasses
  # @param inactiveClasses
  # @param alwaysOpen toggle

  def default(title: "Titile", id: "id", content: "This is the body of the accordion. You can put any content here.", activeClasses: "bg-gray-50", inactiveClasses: "bg-white", alwaysOpen: false)
    render(Ui::Accordion::Component.new(data: { activeClasses: activeClasses, inactiveClasses: inactiveClasses, alwaysOpen: alwaysOpen })) do |accordion|
      accordion.with_item(title: title, id: id) do
        content
      end
    end
  end
end
