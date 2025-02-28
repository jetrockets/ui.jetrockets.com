class Ui::Btn::ComponentPreview < ViewComponent::Preview
  def default
    render(Ui::Btn::Component.new.with_content("Default"))
  end

  def primary
    render(Ui::Btn::Component.new(variant: :primary).with_content("Primary"))
  end

  def secondary
    render(Ui::Btn::Component.new(variant: :secondary).with_content("Secondary"))
  end

  def danger
    render(Ui::Btn::Component.new(variant: :danger).with_content("Danger"))
  end

  def ghost
    render(Ui::Btn::Component.new(variant: :ghost).with_content("Ghost"))
  end

  def link
    render(Ui::Btn::Component.new(variant: :link).with_content("Link"))
  end

  def rounded
    render(Ui::Btn::Component.new(variant: :primary, rounded: true).with_content("Rounded"))
  end

  def with_icon
    render(Ui::Btn::Component.new.with_content("Default").with_icon_content("images/icons/arrow.svg"))
  end

  def outlined
    render(Ui::Btn::Component.new(outlined: true).with_content("Outlined"))
  end

  def circle
    render(Ui::Btn::Component.new(circle: true, size: :xs).with_icon_content("images/icons/arrow.svg"))
  end

  def block
    render(Ui::Btn::Component.new(block: true, variant: :primary, size: :lg).with_content("Block Button"))
  end
end