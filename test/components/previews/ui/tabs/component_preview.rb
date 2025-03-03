class Ui::Tabs::ComponentPreview < ViewComponent::Preview
  def default_tabs
    render(Ui::Tabs::Component.new) do |tabs|
      tabs.with_item(title: "Profile", href: ui_path, icon_path: "images/icons/alert.svg")
      tabs.with_item(title: "Dashboard", href: ui_path, active: true, icon_path: "images/icons/alert.svg")
      tabs.with_item(title: "Settings", href: ui_path, icon_path: "images/icons/alert.svg")
      tabs.with_item(title: "Contacts", href: ui_path, icon_path: "images/icons/alert.svg")
    end
  end
end