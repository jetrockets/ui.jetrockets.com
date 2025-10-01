class Ui::Modal::Component < ApplicationComponent
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
      return dialog_tag id: @id, data: { modals_target: "dialog" } do
        yield
      end
    end

    # If turbo frame request (for example, open modal via link_to with data: { turbo_frame: :modal }), we should use dialog tag inside turbo frame :modal
    if helpers.turbo_frame_request?
      turbo_frame_tag :modal do
        dialog_tag id: :modalDialog, data: { controller: "modal" } do
          turbo_frame_tag :modalContent do
            yield
          end
        end
      end
    # If not using Turbo Frame (open new tab for example), we should use a regular div instead of dialog
    else
      content_tag :div, class: class_names("modal", "w-#{@size}") do
        yield
      end
    end
  end

  def dialog_tag(options = {})
    content_tag :dialog, tabindex: "-1", class: class_names("modal", "animate-slide-up", "w-#{@size}"), **options do
      yield
    end
  end
end
