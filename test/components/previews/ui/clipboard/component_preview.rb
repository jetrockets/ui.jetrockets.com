class Ui::Clipboard::ComponentPreview < ViewComponent::Preview
  # @param label
  # @param value_content
  # @param content_type select :content_options
  # @param default_value
  # @param success_value
  # @param timeout number

  def without_tooltip(
    label: "Clipboard label",
    value_content: "Any content to copy",
    content_type: :input,
    default_value: "Copy",
    success_value: "Copied!",
    timeout: 1000
    )

    render(Ui::Clipboard::Component.new(label: label, value_content: value_content, content_type: content_type, data: { timeout: timeout })) do |clipboard|
      clipboard.with_trigger do |trigger|
        trigger.with_trigger_empty do |t|
          t.with_default(class: "btn btn-primary") do
            default_value
          end
          t.with_success do
            success_value
          end
        end
      end
    end
  end

  # @param label
  # @param value_content
  # @param content_type select :content_options
  # @param default_value
  # @param success_value
  # @param timeout number
  # @param tooltip_placement select :tooltip_placement_options
  # @param tooltip_default
  # @param tooltip_success

  def with_tooltip(
    label: "Clipboard label",
    value_content: "Any content to copy",
    content_type: :input,
    default_value: "Copy",
    success_value: "Copied!",
    timeout: 1000,
    tooltip_placement: :top,
    tooltip_default: "Click to copy",
    tooltip_success: "Successfully copied!"
    )

    render(Ui::Clipboard::Component.new(label: label, value_content: value_content, content_type: content_type, data: { timeout: timeout })) do |clipboard|
      clipboard.with_trigger do |trigger|
        trigger.with_trigger_tooltip(tooltip_placement: tooltip_placement, tooltip_default: tooltip_default, tooltip_success: tooltip_success) do |t|
          t.with_default(class: "btn btn-primary") do
            default_value
          end
          t.with_success do
            success_value
          end
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

  def tooltip_placement_options
    {
      choices: %i[top bottom right left]
    }
  end
end
