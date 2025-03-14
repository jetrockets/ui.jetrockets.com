class Ui::BtnGroup::ComponentPreview < ViewComponent::Preview
  # @param content text
  # @param button_count select :button_count_options
  # @param variant select :variant_options
  # @param size select :size_options
  # @param with_gap toggle
  # @param outlined toggle
  # @param href
  # @param icon

  def default(content: "Button", button_count: 3, variant: :primary, size: :md, with_gap: false, outlined: true, href: nil, icon: nil)
    render(Ui::BtnGroup::Component.new(with_gap:)) do |component|
      button_count.to_i.times do |i|
        component.with_button(variant:, size:, outlined:, href:).with_content(content).with_icon_content(icon)
      end
    end
  end

  private

  def variant_options
    {
      choices: %i[primary secondary danger ghost link],
      include_blank: :default
    }
  end

  def size_options
    {
      choices: %i[xs sm md lg xl]
    }
  end

  def button_count_options
    {
      choices: [ 2, 3, 4, 5 ]
    }
  end
end
