require "shrine"
require "shrine/storage/memory"
require "shrine/storage/file_system"

# For production, use S3 or other cloud storage
# require "shrine/storage/s3"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
}

# Example S3 configuration for production
# if Rails.application.credentials.do.present?
#   s3_options = {
#     access_key_id: Rails.application.credentials.do.s3.access_key_id,
#     secret_access_key: Rails.application.credentials.do.s3.secret_access_key,
#     region: Rails.application.credentials.do.s3.region,
#     endpoint: Rails.application.credentials.do.s3.endpoint,
#     bucket: Rails.application.credentials.do.s3.bucket
#   }

#   Shrine.storages = {
#     cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
#     store: Shrine::Storage::S3.new(**s3_options)
#   }
# end
