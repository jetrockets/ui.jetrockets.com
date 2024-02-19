class Modal::Component < ApplicationComponent
  attr_reader :title, :subtitle

  def initialize(title: nil, subtitle: nil)
    @title = title
    @subtitle = subtitle
  end
end
