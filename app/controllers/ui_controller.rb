class UiController < ApplicationController
  def index
  end

  def getting_started
  end

  def good_to_know
  end

  # Component pages
  def accordion
  end

  def alert
  end

  def avatar
    breadcrumb :ui_avatar
  end

  def badge
    breadcrumb :ui_badge
  end

  def button
    breadcrumb :ui_button
  end

  def button_group
    breadcrumb :ui_button_group
  end

  def card
    breadcrumb :ui_card
  end

  def clipboard
    breadcrumb :ui_clipboard
  end

  def drawer
    breadcrumb :ui_drawer
  end

  def dropdown
    breadcrumb :ui_dropdown
  end

  def flash_message
    breadcrumb :ui_flash_message
  end

  def icon
    breadcrumb :ui_icon
  end

  def modal
    breadcrumb :ui_modal
  end

  def pagy
    breadcrumb :ui_pagy
  end

  def popover
    breadcrumb :ui_popover
  end

  def table
    breadcrumb :ui_table
  end

  def tabs
    breadcrumb :ui_tabs
  end

  def tooltip
    breadcrumb :ui_tooltip
  end

  def turbo_confirm
    breadcrumb :ui_turbo_confirm
  end

  def form_builder
    breadcrumb :ui_form_builder
  end

  def typography
    breadcrumb :ui_typography
  end
end
