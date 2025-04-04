class Ui::Clipboard::ComponentPreview < ViewComponent::Preview
  # @param label
  # @param value_content
  # @param content_type select :content_options
  # @param default_value
  # @param success_value
  # @param timeout number

  def default(label: "Clipboard label", value_content: "Any content to copy", content_type: :input, default_value: "Copy", success_value: "Copied!", timeout: 1000)
    render(Ui::Clipboard::Component.new(label: label, value_content: value_content, content_type: content_type, data: { timeout: timeout })) do |clipboard|
      clipboard.with_trigger do |trigger|
        trigger.with_default(class: "btn btn-primary") do
          default_value
        end
        trigger.with_success do
          success_value
        end
      end
    end
  end

  private

  def content_options
    {
      choices: %i[input innerHTML]
    }
  end
end
