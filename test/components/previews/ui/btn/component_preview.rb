class Ui::Btn::ComponentPreview < ViewComponent::Preview
  # @param content text
  # @param variant select :variant_options
  # @param size select :size_options
  # @param rounded toggle
  # @param block toggle
  # @param circle toggle
  # @param outlined toggle
  # @param href
  # @param icon

  def default(content: "Button", variant: :default, size: :md, rounded: false, block: false, circle: false, outlined: false, href: nil, icon: nil)
    render(Ui::Btn::Component.new(variant:, size:, rounded:, block:, circle:, outlined:, href:).with_content(content).with_icon_content(icon))
  end

  private

  def variant_options
    {
      choices: %i[primary secondary danger ghost link],
      include_blank: :default
    }
  end

  def size_options
    {
      choices: %i[xs sm md lg xl]
    }
  end
end
