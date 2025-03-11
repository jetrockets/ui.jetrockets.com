class Ui::Card::ComponentPreview < ViewComponent::Preview
  # @param header_title
  # @param body_content
  # @param header_bordered toggle
  # @param footer_bordered toggle
  # @param header_align select :header_align_options
  # @param footer_align select :footer_align_options
  # @param button_content
  # @param variant select :variant_options

  def default(
    header_title: "Noteworthy technology acquisitions 2021",
    header_align: :left,
    header_bordered: true,
    body_content: "This is the body of the card. You can put any content here.",
    footer_align: :right,
    footer_bordered: true,
    variant: :primary,
    button_content: "Button"
  )
    render(Ui::Card::Component.new) do |card|
      card.with_header( title: header_title, align: header_align, bordered: header_bordered)

      card.with_body do
        content_tag(:p, body_content)
      end

      card.with_footer(align: footer_align, bordered: footer_bordered) do |footer|
        footer.render(Ui::Btn::Component.new(variant: variant).with_content(button_content))
      end
    end
  end

  private

  def header_align_options
    {
      choices: %i[left center right]
    }
  end

  def footer_align_options
    {
      choices: %i[left center right]
    }
  end

  def variant_options
    {
      choices: %i[primary secondary danger ghost link],
      include_blank: "default"
    }
  end
end