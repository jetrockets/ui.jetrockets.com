class Ui::Breadcrumb::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param bordered toggle
  # @param item_count select :item_count_options
  # @param active_index select :active_index_options
  # @param href
  # @param icon_path
  # @param separator

  def default(title: "Item", item_count: 3, active_index: 2, href: "#", icon_path: "images/icons/alert.svg", separator: "images/icons/arrow.svg", bordered: true)
    render(Ui::Breadcrumb::Component.new(bordered:)) do |breadcrumb|
      item_count.to_i.times do |i|
        is_active = (i == active_index.to_i)
        is_last = (i == item_count.to_i - 1)
        breadcrumb.with_item(title:, href:, icon_path:, separator: is_last ? nil : separator, active: is_active)
      end
    end
  end

  private

  def item_count_options
    {
      choices: [3, 4]
    }
  end

  def active_index_options
    {
      choices: [0, 1, 2]
    }
  end
end