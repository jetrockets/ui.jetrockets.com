class Ui::Pagy::ComponentPreview < ViewComponent::Preview
  # @param href
  # @param use_arrows toggle
  # @param disabled_prev toggle
  # @param disabled_next toggle
  # @param arrow_icon_path
  # @param page_count select :page_count_options
  # @param active_page select :active_page_options
  # @param size select :size_options

  def default(href: "#", use_arrows: true, arrow_icon_path: "images/icons/arrow.svg", page_count: 5, active_page: 2, size: :md, disabled_prev: false, disabled_next: false)
    render(Ui::Pagy::Component.new(size:)) do |pagination|
      if use_arrows
        pagination.with_item(href:, icon_path: arrow_icon_path, direction: :left, disabled: disabled_prev)
      else
        pagination.with_item(title: "Previous", disabled: disabled_prev)
      end

      page_count.to_i.times do |i|
        page_number = (i + 1).to_s
        is_active = (i == active_page.to_i)
        pagination.with_item(title: page_number, href:, active: is_active)
      end

      if use_arrows
        pagination.with_item(href:, icon_path: arrow_icon_path, direction: :right, disabled: disabled_next)
      else
        pagination.with_item(title: "Next", disabled: disabled_next)
      end
    end
  end

  private

  def size_options
    {
      choices: %i[xs sm md lg xl]
    }
  end

  def page_count_options
    {
      choices: [ 5, 6 ]
    }
  end

  def active_page_options
    {
      choices: [ 0, 1, 2, 3, 4 ]
    }
  end
end
