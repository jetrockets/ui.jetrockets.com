class Ui::Select::ComponentPreview < ViewComponent::Preview
  # @param id
  # @param choices

  def default(id: "select1", choices: "Rails,Hotwire,Turbo,Stimulus,Tailwind,CSS,HTML,React,JS,Python,Svelte,C,C#,C++")
    render(Ui::Select::Component.new(id: id, class: "w-1/2", data: { choices: choices }))
  end
end
