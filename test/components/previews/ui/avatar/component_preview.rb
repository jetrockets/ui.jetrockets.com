class Ui::Avatar::ComponentPreview < ViewComponent::Preview
  # @param full_name text
  # @param size select :size_options
  # @param variant select :variant_options

  def default(size: :md, full_name: "John Doe", variant: :circle)
    render(Ui::Avatar::Component.new(size:, full_name:, variant:))
  end

  private

  def size_options
    {
      choices: %i[xs sm md lg xl]
    }
  end

  def variant_options
    {
      choices: %i[rounded circle]
    }
  end
end
