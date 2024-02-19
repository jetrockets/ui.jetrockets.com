class Modal::Component < ApplicationComponent
  def initialize(title: nil, subtitle: nil)
    @title = title
    @subtitle = subtitle
  end

  protected

  attr_reader :title, :subtitle
end
