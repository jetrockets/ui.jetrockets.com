class Ui::Badge::ComponentPreview < ViewComponent::Preview
  def blue_xs
    render(Ui::Badge::Component.new(title: "Blue XS", variant: :blue, size: :xs))
  end

  def default
    render(Ui::Badge::Component.new(title: "Default"))
  end

  def red_sm
    render(Ui::Badge::Component.new(title: "Red SM", variant: :red, size: :sm))
  end

  def green_md
    render(Ui::Badge::Component.new(title: "Green MD", variant: :green, size: :md))
  end

  def yellow_lg
    render(Ui::Badge::Component.new(title: "Yellow LG", variant: :yellow, size: :lg))
  end
end
