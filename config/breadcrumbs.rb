crumb :root do
  link "JR Components", root_path
end

crumb :ui do
  link "Introduction", ui_path
end

crumb :profile do
  link "Profile", user_profile_path
  parent :root
end

# UI Documentation
crumb :ui_getting_started do
  link "Getting Started", ui_getting_started_path
end

crumb :ui_good_to_know do
  link "Good to know", ui_good_to_know_path
end

# Component breadcrumbs
crumb :ui_accordion do
  link "Accordion", ui_accordion_path
end

crumb :ui_alert do
  link "Alert", ui_alert_path
end

crumb :ui_avatar do
  link "Avatar", ui_avatar_path
end

crumb :ui_badge do
  link "Badge", ui_badge_path
end

crumb :ui_button do
  link "Button", ui_button_path
end

crumb :ui_button_group do
  link "Button Group", ui_button_group_path
end

crumb :ui_card do
  link "Card", ui_card_path
end

crumb :ui_clipboard do
  link "Clipboard", ui_clipboard_path
end

crumb :ui_drawer do
  link "Drawer", ui_drawer_path
end

crumb :ui_dropdown do
  link "Dropdown", ui_dropdown_path
end

crumb :ui_flash_message do
  link "Flash Message", ui_flash_message_path
end

crumb :ui_form_builders_core do
  link "Core Form Builder", ui_form_builders_core_path
end

crumb :ui_form_builders_default do
  link "Default Form Builder", ui_form_builders_default_path
end

crumb :ui_icon do
  link "Icon", ui_icon_path
end

crumb :ui_modal do
  link "Modal", ui_modal_path
end

crumb :ui_pagy do
  link "Pagy", ui_pagy_path
end

crumb :ui_popover do
  link "Popover", ui_popover_path
end

crumb :ui_table do
  link "Table", ui_table_path
end

crumb :ui_tabs do
  link "Tabs", ui_tabs_path
end

crumb :ui_tooltip do
  link "Tooltip", ui_tooltip_path
end

crumb :ui_turbo_confirm do
  link "Turbo Confirm", ui_turbo_confirm_path
end

crumb :ui_typography do
  link "Typography", ui_typography_path
end

crumb :privacy_policy do
  link "Privacy Policy", privacy_path
  parent :root
end

crumb :terms_and_conditions do
  link "Terms and conditions", terms_path
  parent :root
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
