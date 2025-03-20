class Ui::Typography::ComponentPreview < ViewComponent::Preview
  def default
    content = <<~HTML
      <h1 class="h1">Heading 1</h1>
      <h2 class="h2">Heading 2</h2>
      <h3 class="h3">Heading 3</h3>
      <h4 class="h4">Heading 4</h4>
      <h5 class="h5">Heading 5</h5>
      <h6 class="h6">Heading 6</h6>

      <p class="p">Text</p>

      <h6 class="h6">Unordered list</h6>
      <ul class="ul">
        <li class="li">Item 1</li>
        <li class="li">Item 2</li>
        <li class="li">Item 3</li>
      </ul>

      <h6 class="h6">Ordered list</h6>
      <ol class="ol">
        <li class="li">Item 1</li>
        <li class="li">Item 2</li>
        <li class="li">Item 3</li>
      </ol>
    HTML

    render ApplicationComponent.new do
      content.html_safe
    end
  end
end
