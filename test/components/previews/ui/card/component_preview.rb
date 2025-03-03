class Ui::CardComponentPreview < ViewComponent::Preview
  def button_left
    render Ui::Card::Component.new do |component|
      component.with_header align: :left, title: "Noteworthy technology acquisitions 2021"

      component.with_body do
        content_tag(:p, "This is the body of the card. You can put any content here.")
      end

      component.with_footer(align: :left) do
        render Ui::Btn::Component.new(variant: :secondary).with_content("Primary")
      end
    end
  end

  def button_right
    render Ui::Card::Component.new do |component|
      component.with_header align: :left, title: "Noteworthy technology acquisitions 2021"

      component.with_body do
        content_tag(:p, "This is the body of the card. You can put any content here.")
      end

      component.with_footer(align: :right) do
        render Ui::Btn::Component.new(variant: :secondary).with_content("Primary")
      end
    end
  end
end