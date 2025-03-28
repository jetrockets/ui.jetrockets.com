class Ui::Dropdown::ComponentPreview < ViewComponent::Preview
  # @param trigger_title
  # @param menu_title
  # @param item_content
  # @param link_title
  # @param link_href
  # @param placement select :placement_options
  # @param triggerType select :trigger_options
  # @param offsetSkidding number
  # @param offsetDistance number
  # @param delay number
  # @param ignoreClickOutsideClass toggle

  def default(
    trigger_title: "Dropdown",
    menu_title: "Title",
    item_content: "Any content",
    link_title: "Settings",
    link_href: "#",
    placement: :bottom,
    triggerType: :click,
    offsetSkidding: 0,
    offsetDistance: 5,
    delay: 300,
    ignoreClickOutsideClass: false
    )

    render(Ui::Dropdown::Component.new(data: { placement: placement, triggerType: triggerType, offsetSkidding: offsetSkidding, offsetDistance: offsetDistance, delay: delay, ignoreClickOutsideClass: ignoreClickOutsideClass })) do |dropdown|
      dropdown.with_trigger(class: "btn btn-primary btn-iconed") do
        trigger_title
      end

      dropdown.with_menu do |list|
        list.with_title { menu_title }

        list.with_element_item do
          item_content
        end

        list.with_element_divider
        list.with_element_link(title: link_title, href: link_href)
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
