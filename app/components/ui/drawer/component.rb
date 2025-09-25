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
        content_tag :div, class: drawer__window_classes do
          yield
        end
      end
    end
  end

  def async_container_tag(&block)
    if helpers.turbo_frame_request?
      turbo_frame_tag :drawer do
        content_tag :div, id: "drawerTurbo", tabindex: "-1", data: { controller: "drawer-turbo" }, class: "drawer" do
          content_tag :div, class: drawer__window_classes do
            yield
          end
        end
      end
    else
      content_tag :div, class: "flex-1 w-fit" do
        content_tag :div, class: drawer__window_classes do
          yield
        end
      end
    end
  end

  def drawer__window_classes
    class_names(
      "drawer__window",
      "max-w-#{@size}"
    )
  end

  def close_btn
    if (helpers.respond_to?(:turbo_frame_request?) && helpers.turbo_frame_request?) || !@async
      is_turbo = helpers.respond_to?(:turbo_frame_request?) && helpers.turbo_frame_request?

      attributes = {
        type: "button",
        class: "drawer__close"
      }

      if is_turbo
        attributes["data-action"] = "click->drawer-turbo#close"
      else
        attributes["data-action"] = "click->drawer#close"
        attributes["aria-label"] = "Close"
        attributes["data-id"] = @id if @id.present?
      end

      tag.button(**attributes) do
        helpers.vite_icon_tag "close.svg"
      end
    end
  end
end
