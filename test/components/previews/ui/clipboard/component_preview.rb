class Ui::Clipboard::ComponentPreview < ViewComponent::Preview
  # @param value
  # @param id
  # @param default
  # @param success
  # @param timeout number
  # @param tooltip_default
  # @param tooltip_success
  # @param tooltip_placement select :tooltip_placement_options

  def default(
    value: "Any content to copy",
    id: "clipboard1",
    default: Ui::Btn::Component.new(variant: :primary).with_content("Copy content"),
    success: Ui::Btn::Component.new(variant: :primary).with_content("COPIED!"),
    timeout: 1000,
    tooltip_default: "Click me to copy",
    tooltip_success: "Siccessfully copied!",
    tooltip_placement: :bottom
    )

    render(Ui::Clipboard::Component.new(value: value, id: id, data: { timeout: timeout })) do |clipboard|
      clipboard.with_trigger(default: default, success: success, tooltip_default: tooltip_default, tooltip_success: tooltip_success, tooltip_placement: tooltip_placement)
    end
  end

  private

  def tooltip_placement_options
    {
      choices: %i[top bottom right left]
    }
  end
end
