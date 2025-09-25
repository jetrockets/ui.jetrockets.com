# frozen_string_literal: true

class Ui::Modal::Component < ApplicationComponent
  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  def initialize(title: nil, subtitle: nil, size: DEFAULT_SIZE, async: true, id: nil)
    super
    @title = title
    @subtitle = subtitle
    @size = size
    @async = async
    @id = id
  end

  private

  def container_tag
    if @async
      async_container_tag do
        yield
      end
    else
      content_tag :div, id: @id, data: { modal_target: "modal" }, tabindex: "-1", aria: { hidden: "true" }, class: "modal" do
        content_tag :div, class: modal__window_classes do
          yield
        end
      end
    end
  end

  def async_container_tag(&block)
    if helpers.turbo_frame_request?
      turbo_frame_tag :modal do
        content_tag :div, id: "modalTurbo", tabindex: "-1", data: { controller: "modal-turbo" }, class: "modal" do
          turbo_frame_tag :modalWindow, class: modal__window_classes do
            yield
          end
        end
      end
    else
      # If not using Turbo Frame (open new tab for example), we can use a regular div
      content_tag :div, class: "flex-1" do
        content_tag :div, class: modal__window_classes do
          yield
        end
      end
    end
  end

  def modal__window_classes
    class_names(
      "modal__window",
      "max-w-#{@size}"
    )
  end
end
