class Ui::Clipboard::SuccessComponent < ApplicationComponent
  def initialize(**options)
    @options = options
    @options[:data] ||= {}
    @options[:data][:clipboard_target] = "success"
  end

  def call
    content_tag :span, content, class: "hidden", **@options
  end
end
