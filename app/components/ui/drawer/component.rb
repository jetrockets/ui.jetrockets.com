class Ui::Drawer::Component < ApplicationComponent
  def initialize(title: nil, **options)
    super
    @title = title
    @options = options
  end

  private

  def container_tag
    content_tag :div, id: "drawer", tabindex: "-1", data: { drawer_target: "drawer" }, class: "drawer -translate-x-full" do
      yield
    end
  end
end
