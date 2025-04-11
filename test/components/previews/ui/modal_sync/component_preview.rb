class Ui::ModalSync::ComponentPreview < ViewComponent::Preview
  # @!group Sizes

  def modal_trigger(id: "modalComponent")
    render(Ui::Btn::Component.new(variant: :primary, data: { modal_target: "trigger", modal_toggle: "modal", action: "click->modal#show", id: id }).with_content("Open modal"))
  end

  def modal(title: "Modal Title", subtitle: "Modal Subtitle", modal_content: "Any content inside modal", id: "modalComponent")
    render(Ui::Modal::Component.new(title: title, subtitle: subtitle, async: false, id: id)) do
      modal_content
    end
  end
end
