class Ui::Clipboard::ComponentPreview < ViewComponent::Preview
  # @param label
  # @param value_content
  # @param default_value
  # @param success_value

  def default(label: "Clipboard label", value_content: "Any content to copy", default_value: "Copy", success_value: "Copied!")
    render(Ui::Clipboard::Component.new(label: label, value_content: value_content)) do |clipboard|
      clipboard.with_default do
        default_value
      end
      clipboard.with_success do
        success_value
      end
    end
  end
end
