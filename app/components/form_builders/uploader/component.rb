class FormBuilders::Uploader::Component < ApplicationComponent
  VARIANTS = %i[dropzone button].freeze
  DEFAULT_VARIANT = :dropzone

  SIZES = %i[sm md lg].freeze
  DEFAULT_SIZE = :md

  def initialize(name:, id: nil, variant: DEFAULT_VARIANT, size: DEFAULT_SIZE, multiple: false, accept: nil,
                 max_file_size: nil, max_files: nil, disabled: false, required: false, errored: false,
                 prompt: nil, caption: nil, button_label: nil, **options)
    super()
    @name = name
    @id = id
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @size = SIZES.include?(size) ? size : DEFAULT_SIZE
    @multiple = multiple
    @accept = Array(accept).join(",").presence
    @max_file_size = max_file_size
    @max_files = max_files
    @disabled = disabled
    @required = required
    @errored = errored
    @prompt = prompt
    @caption = caption
    @button_label = button_label
    @options = options
  end

  private

  def dropzone?
    @variant == :dropzone
  end

  def prompt
    @prompt || (@multiple ? "Click to upload files" : "Click to upload")
  end

  def button_label
    @button_label || (@multiple ? "Choose files" : "Choose file")
  end

  def caption
    return @caption if @caption

    parts = []
    parts << "Up to #{helpers.number_to_human_size(@max_file_size)}" if @max_file_size
    parts << "max #{helpers.pluralize(@max_files, 'file')}" if @multiple && @max_files
    parts.join(" · ").presence
  end

  def classes
    class_names(
      "uploader",
      { "uploader-button": @variant == :button },
      { "uploader-sm": @size == :sm },
      { "uploader-lg": @size == :lg },
      { "uploader-disabled": @disabled },
      { "uploader-errored": @errored },
      @options.delete(:class)
    )
  end

  def data
    {
      controller: "uploader",
      uploader_multiple_value: @multiple,
      uploader_disabled_value: @disabled,
      uploader_max_file_size_value: @max_file_size,
      uploader_max_files_value: (@max_files if @multiple),
      uploader_allowed_file_types_value: @accept&.split(",")&.map(&:strip)&.to_json
    }.compact.merge(@options.delete(:data) || {})
  end

  def input_options
    {
      type: "file",
      name: @name,
      id: @id,
      class: "uploader__input",
      multiple: @multiple,
      accept: @accept,
      disabled: @disabled,
      required: @required,
      data: { uploader_target: "input", action: "change->uploader#select" }
    }
  end

  def button_size
    @size == :md ? :md : @size
  end
end
