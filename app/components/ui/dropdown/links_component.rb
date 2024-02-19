class Ui::Dropdown::LinksComponent < ApplicationComponent
  def initialize(name:, href:, **options)
    @name = name
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <li>
      <%= link_to @name, @href, class: "block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white", **@options %>
    </li>
  ERB
end
