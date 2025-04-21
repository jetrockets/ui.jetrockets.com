class Ui::Select::ComponentPreview < ViewComponent::Preview
  # @param id
  # @param content

  def default(id: "select1", content: "Rails,Hotwire,Turbo,Stimulus,Tailwind,CSS,HTML,React,JS,Python,Svelte,C,C#,C++")
    render(Ui::Select::Component.new(id: id, class: "w-1/2"), content: content) do
      safe_join(
        content.split(",").map do |option|
          tag.option(option, value: option)
        end
      )
    end
  end
end
