class Ui::Tabs::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param item_count select :item_count_options
  # @param active_index select :active_index_options
  # @param icon_path
  # @param href

  def default(title: "Tab", item_count: 4, active_index: 1, icon_path: "images/icons/alert.svg", href: "/ui")
    render(Ui::Tabs::Component.new) do |tabs|
      item_count.to_i.times do |i|
        is_active = (i == active_index.to_i)
        tabs.with_item(title:, href:, active: is_active, icon_path: )
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
      choices: [0, 1, 2, 3]
    }
  end
end