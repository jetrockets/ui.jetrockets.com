class Ui::Popover::ComponentPreview < ViewComponent::Preview
  # @param trigger_title
  # @param popover_title
  # @param popover_content
  # @param placement select :placement_options
  # @param triggerType select :trigger_options

  def default(
    trigger_title: "Default popover",
    popover_title: "Popover Title",
    popover_content: "And here's some amazing content. It's very engaging.",
    placement: :bottom,
    triggerType: :hover
  )

    render(Ui::Popover::Component.new(data: { placement: placement, triggerType: triggerType })) do |popover|
      popover.with_trigger(class: "btn mr-2") do
        trigger_title
      end
      popover.with_menu(title: popover_title) do
        content_tag(:p, popover_content)
      end
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
