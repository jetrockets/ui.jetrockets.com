module FormatHelper
  def date_format(date, format = :default)
    date && I18n.l(date, format: format)
  end
end
