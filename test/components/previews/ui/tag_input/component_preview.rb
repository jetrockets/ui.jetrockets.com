class Ui::TagInput::ComponentPreview < ViewComponent::Preview
  # @param placeholder
  # @param default_value
  # @param whitelist
  # @param maxItems number
  # @param closeOnSelect toggle

  def default(placeholder: "Choose your stack", default_value: "Ruby", whitelist: "Rails,Hotwire,Turbo,Stimulus,Tailwind,CSS,HTML,React,JS,Python,Svelte", maxItems: 10, closeOnSelect: false)
    render(Ui::TagInput::Component.new(placeholder: placeholder, value: default_value, data: { whitelist: whitelist, maxItems: maxItems, closeOnSelect: closeOnSelect }))
  end
end
