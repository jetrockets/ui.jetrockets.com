class Ui::Drawer::Component < ApplicationComponent
  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  def initialize(title: nil, async: true, id: nil, size: DEFAULT_SIZE, **options)
    super
    @title = title
    @async = async
    @id = id
    @size = size
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
        content_tag :div, class: drawer__container_classes do
          yield
        end
      end
    end
  end

  def async_container_tag(&block)
    if helpers.turbo_frame_request?
      turbo_frame_tag :drawer do
        content_tag :div, id: "drawerTurbo", tabindex: "-1", data: { controller: "drawer-turbo" }, class: "drawer" do
          content_tag :div, class: drawer__container_classes do
            yield
          end
        end
      end
    else
      content_tag :div, class: "flex-1 w-fit" do
        content_tag :div, class: drawer__container_classes do
          yield
        end
      end
    end
  end

  def drawer__container_classes
    class_names(
      "drawer__container",
      "max-w-#{@size}"
    )
  end
end
