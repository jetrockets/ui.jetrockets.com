class Ui::Tooltip::ComponentPreview < ViewComponent::Preview
  # @param trigger_content
  # @param tooltip_content
  # @param placement select :placement_options
  # @param triggerType select :trigger_options

  def default(trigger_content: "Tooltip trigger", tooltip_content: "Tooltip content", placement: :top, triggerType: :hover)
    render(Ui::Tooltip::Component.new(tooltip_content: tooltip_content, data: { placement: placement, triggerType: triggerType }, class: "btn btn-primary")) do
      trigger_content
    end
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
