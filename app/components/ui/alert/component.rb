class Ui::Alert::Component < ApplicationComponent
  TYPES = %w[info error success warning default]
  DEFAULT_TYPE = :default

  def initialize(type: DEFAULT_TYPE, **options)
    @type = type
  end

  erb_template <<~ERB
    <div class="<%= classes %>" role="alert" **options>
      <%= content %>
    </div>
  ERB

  def classes
    class_names(
      "p-4 mb-4 text-sm rounded-lg",
      "text-blue-800 bg-blue-50 bg-blue-50": @type == :info,
      "text-red-800 bg-red-50 bg-red-50": @type == :error,
      "text-green-800 bg-green-50 bg-green-50": @type == :success,
      "text-yellow-800 bg-yellow-50 bg-yellow-50": @type == :warning,
      "text-gray-800 bg-gray-50 bg-gray-50": @type == :default
    )
  end
end
