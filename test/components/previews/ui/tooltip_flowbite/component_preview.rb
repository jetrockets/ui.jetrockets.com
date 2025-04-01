class Ui::TooltipFlowbite::ComponentPreview < ViewComponent::Preview
  # @param trigger
  # @param tooltip_content
  # @param placement select :placement_options
  # @param triggerType select :trigger_options

  def default(trigger: "Tooltip Flowbite", tooltip_content: "Tooltip content", placement: :top, triggerType: :hover)
    render(Ui::TooltipFlowbite::Component.new(trigger: trigger, tooltip_content: tooltip_content, data: { placement: placement, triggerType: triggerType }, class: "btn btn-primary"))
  end

  private

  def placement_options
    {
      choices: %i[bottom left right top]
    }
  end

  def trigger_options
    {
      choices: %i[click hover none]
    }
  end
end
