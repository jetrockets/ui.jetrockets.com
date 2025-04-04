class Ui::Clipboard::DefaultComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "default"
  end

  def call
    content_tag :span, content, **@options
  end
end
