module FormatHelper
  def date_format(date, format: :default, default: nil)
    return default if date.blank?
    I18n.l(date, format: format)
  end
end
