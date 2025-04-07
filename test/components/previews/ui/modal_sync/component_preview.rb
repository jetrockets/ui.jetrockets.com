class Ui::ModalSync::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param subtitle
  # @param modal_content
  # @param trigger_title
  # @param trigger_class
  # @param placementVertical select :placementVertical_options
  # @param placementHorizontal select :placementHorizontal_options

  def default(title: "Modal Title", subtitle: "Modal Subtitle", modal_content: "Any content inside modal", trigger_title: "Modal Trigger", trigger_class: "btn", placementVertical: :center, placementHorizontal: :left)
    render(Ui::Modal::Component.new(title: title, subtitle: subtitle, trigger_title: trigger_title, trigger_class: trigger_class, data: { placementVertical: placementVertical, placementHorizontal: placementHorizontal })) do
      modal_content
    end
  end
end

def placementVertical_options
  {
    choices: %i[bottom top center]
  }
end

def placementHorizontal_options
  {
    choices: %i[left right center]
  }
end
