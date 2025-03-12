class Ui::Avatar::ComponentPreview < ViewComponent::Preview
  # @param name text
  # @param icon_path
  # @param size select :size_options
  # @param rounded toggle
  # @param circle toggle
  # @param bordered toggle

  def default(size: :md, name: "John Doe", icon_path: "images/icons/user.svg", rounded: false, circle: true, bordered: false)
    render(Ui::Avatar::Component.new(size:, name:, rounded:, circle:, bordered:)) do |avatar|
      if icon_path
        avatar.with_icon_content(icon_path)
      end
    end
  end

  private

  def size_options
    {
      choices: %i[xs sm md lg xl]
    }
  end
end