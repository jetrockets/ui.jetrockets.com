class Ui::Alert::ComponentPreview < ViewComponent::Preview

  def danger_alert
    render(Ui::Alert::Component.new(type: :error, title: "Danger alert!"))
  end

  def success_alert
    render(Ui::Alert::Component.new(type: :success, title: "Success alert!"))
  end

  def warning_alert
    render(Ui::Alert::Component.new(type: :warning, title: "Warning alert!"))
  end

  def default_alert
    render(Ui::Alert::Component.new(title: "Default alert!"))
  end
end
