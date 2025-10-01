class Ui::Drawer::Component < ApplicationComponent
  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  def initialize(title: nil, subtitle: nil, size: DEFAULT_SIZE, id: nil)
    super
    @title = title
    @subtitle = subtitle
    @size = size
    @id = id
  end

  private

  def container_tag
    # If @id is provided, we assume it's a sync dialog.
    if @id
      return dialog_tag id: @id, data: { drawers_target: "dialog" } do
        yield
      end
    end

    # If turbo frame request (for example, open drawer via link_to with data: { turbo_frame: :drawer }), we should use dialog tag inside turbo frame :drawer
    if helpers.turbo_frame_request?
      turbo_frame_tag :drawer do
        dialog_tag id: :drawerDialog, data: { controller: "drawer" } do
          turbo_frame_tag :drawerContent do
            yield
          end
        end
      end
    # If not using Turbo Frame (open new tab for example), we should use a regular div instead of dialog
    else
      content_tag :div, class: class_names("drawer", "w-#{@size}") do
        yield
      end
    end
  end

  def dialog_tag(options = {})
    content_tag :dialog, tabindex: "-1", class: class_names("drawer", "animate-slide-left", "w-#{@size}"), **options do
      yield
    end
  end
end
