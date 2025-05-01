class Ui::Drawer::Component < ApplicationComponent
  def initialize(title: nil, async: true, id: nil, **options)
    super
    @title = title
    @async = async
    @id = id
    @options = options
  end

  private

  def container_tag
    if @async
      async_container_tag do
        yield
      end
    else
      content_tag :div, id: @id, tabindex: "-1", data: { drawer_target: "drawer" }, class: "drawer translate-x-full" do
        yield
      end
    end
  end

  def async_container_tag(&block)
    if helpers.turbo_frame_request?
      turbo_frame_tag :drawer do
        content_tag :div, id: "drawerTurbo", tabindex: "-1", data: { controller: "drawer-turbo" }, class: "drawer" do
          yield
        end
      end
    else
      content_tag :div, class: "flex-1 max-w-5xl" do
        yield
      end
    end
  end
end
