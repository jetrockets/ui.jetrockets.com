class Ui::Tabs::ItemComponent < ApplicationComponent
  attr_reader :title, :href, :options

  def initialize(title:, href:, **options)
    @title = title
    @href = href
    @options = options
  end

  erb_template <<~ERB
    <%= link_to title, href, class: "tabs__link", **options %>
  ERB
end
