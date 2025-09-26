class AvatarUploader < ApplicationUploader
  IMAGE_MIME_TYPES = %w[image/jpeg image/jpg image/png image/webp].freeze
  MAX_FILESIZE = 8.megabytes

  Attacher.validate do
    validate_mime_type IMAGE_MIME_TYPES, message: "only allows (jpeg png jpg webp)"
    validate_max_size MAX_FILESIZE
  end

  Attacher.derivatives do |original|
    image = ImageProcessing::Vips.source(original).convert("jpeg").saver(
      quality: 75,
      interlace: "JPEG",
      sampling_factor: "4:2:0",
      strip: true,
      colorspace: "sRGB"
    )

    avif = ImageProcessing::Vips.source(original).convert("avif").saver(quality: 50)
    {
      square_300: image.resize_to_fill!(300, 300),
      square_300_avif: avif.resize_to_fill!(300, 300)
    }
  end
end
