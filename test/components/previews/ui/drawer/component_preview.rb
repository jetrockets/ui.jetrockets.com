class Ui::Drawer::ComponentPreview < ViewComponent::Preview
  # @!group Sizes

  def drawer_trigger
    render(Ui::Btn::Component.new(variant: :primary, data: { drawer_target: "trigger", drawer_toggle: "drawer", action: "click->drawer#show" }).with_content("Show drawer"))
  end

  def darawer(title: "Drawer Title", drawer_content: "Any amazing content")
    render(Ui::Drawer::Component.new(title: title, async: false)) do
      tag.div(drawer_content, class: "text-white")
    end
  end
end
