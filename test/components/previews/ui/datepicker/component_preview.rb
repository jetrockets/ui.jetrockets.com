class Ui::Datepicker::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param placeholder
  # @param format
  # @param autohide toggle
  # @param range toggle
  # @param disabledDates

  def default(title: "Datepicker", placeholder: "Datepicker placeholder", format: "YYYY-MM-DD", autohide: true, range: true, disabledDates: "2025-04-13, 2025-04-15, 2025-04-18")
    render(Ui::Datepicker::Component.new(title: title, placeholder: placeholder, id: "picker", data: { format: format, autohide: autohide, range: range, disabledDates: disabledDates }))
  end
end
