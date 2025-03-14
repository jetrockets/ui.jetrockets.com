class Ui::Badge::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param variant select :variant_options
  # @param size select :size_options

  def default(title: "Badge", variant: :default, size: :sm)
    render(Ui::Badge::Component.new(title: title, variant: variant, size: size))
  end

  private

  def variant_options
    {
      choices: %i[default blue red green yellow]
    }
  end

  def size_options
    {
      choices: %i[xs sm md lg]
    }
  end
end
