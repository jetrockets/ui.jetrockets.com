class Ui::Dropdown::LinkComponent < ApplicationComponent
  def initialize(title: nil, href: nil, **options)
    @title = title
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <li class="dropdown__item">
      <%= link_to @title, @href, **@options %>
    </li>
  ERB
end
