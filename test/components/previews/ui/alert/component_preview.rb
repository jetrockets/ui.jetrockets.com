class Ui::Alert::ComponentPreview < ViewComponent::Preview
  # @param title
  # @param type select :type_options
  # @param icon_path
  # @param content

  def default(title: "Default alert!", type: :default, icon_path: "images/icons/alert.svg", content: nil)
    render Ui::Alert::Component.new(title:, type:, icon_path:) do
      content
    end
  end

  private

  def type_options
    {
      choices: %i[success warning error],
      include_blank: :default
    }
  end
end
