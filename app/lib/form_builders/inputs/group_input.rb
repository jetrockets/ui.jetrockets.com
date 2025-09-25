module FormBuilders
  module Inputs
    class GroupInput < BaseInput
      def initialize(form_builder, method = nil, options = {}, &block)
        @form_builder = form_builder
        @method = method
        @options = options
        @template = form_builder.instance_variable_get(:@template)
        @object = form_builder.object
        @block = block
      end

      def render
        classes = build_group_classes
        
        @template.content_tag(:div, class: classes, **@options.except(:class)) do
          @block ? @block.call : ""
        end
      end

      private

      def build_group_classes
        classes = ["form__group"]
        classes << "form__group-errored" if @method && errors_for?(@method)
        classes << @options[:class] if @options[:class]
        classes.compact.join(" ")
      end

      def errors_for?(method)
        @object&.errors&.any? && @object&.errors[method.to_sym]&.any?
      end
    end
  end
end