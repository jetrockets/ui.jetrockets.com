class Ui::BtnGroup::ComponentPreview < ViewComponent::Preview
  def default
    render(Ui::BtnGroup::Component.new) do |component|
      component.with_button(variant: :primary, outlined: true) { "Button Second" }
      component.with_button(variant: :primary, outlined: true) { "Button Third" }
    end
  end

  def with_gap
    render(Ui::BtnGroup::Component.new(with_gap: true)) do |component|
      component.with_button(variant: :primary, outlined: true) { "Button With Gap" }
      component.with_button(variant: :primary, outlined: true) { "Button With Gap" }
      component.with_button(variant: :primary, outlined: true) { "Button With Gap" }
    end
  end
end
