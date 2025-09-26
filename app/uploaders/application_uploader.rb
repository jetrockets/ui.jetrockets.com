class ApplicationUploader < Shrine
  plugin :activerecord
  plugin :cached_attachment_data
  plugin :derivatives, create_on_promote: true
  plugin :restore_cached_data
  plugin :validation_helpers
  plugin :determine_mime_type, analyzer: :fastimage
  plugin :upload_endpoint
  plugin :default_url, host: Rails.application.config.action_controller.asset_host
end
