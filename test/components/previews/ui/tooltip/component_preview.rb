class Ui::Tooltip::ComponentPreview < ViewComponent::Preview
  # @param button_title
  # @param content
  # @param placement select :placement_options
  # @param animation select :animation_options
  # @param theme select :theme_options

  def default(button_title: "Tooltip", content: "Tooltip content", placement: :top, animation: :scale, theme: :light)
    render(Ui::Tooltip::Component.new(data: { content: content, placement: placement, animation: animation, theme: theme }, class: "btn btn-primary")) do
      button_title
    end
  end

  private

  def placement_options
    {
      choices: %i[bottom left right top]
    }
  end

  def animation_options
    {
      choices: %i[scale shift-away shift-toward perspective]
    }
  end

  def theme_options
    {
      choices: %i[light light-border material translucent]
    }
  end
end
