class Ui::Table::ComponentPreview < ViewComponent::Preview
  include ActionView::Helpers::NumberHelper

  # @param payment_content
  # @param status_content
  # @param amount_content
  # @param date_content
  # @param footer_total_content
  # @param footer_amount_content
  # @param size select :size_options
  # @param badge_variant select :badge_variant_options
  # @param button_variant select :variant_options
  # @param button_size select :button_size_options
  # @param button_outlined toggle
  # @param bordered toggle
  # @param full toggle
  # @param hovered toggle
  # @param left_sticky toggle
  # @param right_sticky toggle

  def default(
    size: :xs,
    bordered: true,
    full: true,
    hovered: true,
    left_sticky: true,
    right_sticky: false,
    payment_content: "Payment Name",
    status_content: "Status",
    amount_content: 1200,
    date_content: I18n.l(Time.zone.now, format: :full_month),
    footer_total_content: "Total",
    footer_amount_content: 2400,
    badge_variant: :green,
    button_variant: :primary,
    button_size: :sm,
    button_outlined: true
  )
    render(Ui::Table::Component.new(size:, bordered:, full:, hovered:)) do |table|
      table.with_thead do |thead|
        thead.with_tr do |tr|
          tr.with_th(sticky: sticky_value(left_sticky, :left)) { "Payment" }
          tr.with_th { "Status" }
          tr.with_th { "Amount" }
          tr.with_th { "Created At" }
          tr.with_th(sticky: sticky_value(right_sticky, :right)) { "Actions" }
        end
      end

      table.with_tbody do |tbody|
        2.times do |row|
          tbody.with_tr do |tr|
            tr.with_td(sticky: sticky_value(left_sticky, :left), class: "w-4/12") { payment_content }
            tr.with_td do |td|
              td.render(Ui::Badge::Component.new(title: status_content, variant: badge_variant))
            end
            tr.with_td(class: "whitespace-nowrap") { number_to_currency(amount_content) }
            tr.with_td(class: "whitespace-nowrap") { date_content }
            tr.with_td(sticky: sticky_value(right_sticky, :right), actions: true) do |td|
              btn_group = Ui::BtnGroup::Component.new
              btn_group.with_button(variant: button_variant, size: button_size, outlined: button_outlined) { "Show" }
              btn_group.with_button(variant: button_variant, size: button_size, outlined: button_outlined) { "Edit" }
              td.render(btn_group)
            end
          end
        end
      end

      table.with_tfoot do |tfoot|
        tfoot.with_tr do |tr|
          tr.with_td(colspan: 2) { footer_total_content }
          tr.with_td(colspan: 3) { number_to_currency(footer_amount_content) }
        end
      end
    end
  end

  private

  def sticky_value(sticky_enabled, position)
    sticky_enabled ? position : false
  end

  def size_options
    {
      choices: %i[xs sm md lg],
    }
  end

  def badge_variant_options
    {
      choices: %i[green red],
    }
  end

  def variant_options
    {
      choices: %i[primary secondary danger ghost link],
      include_blank: "default"
    }
  end

  def button_size_options
    {
      choices: %i[xs sm md lg xl],
    }
  end
end