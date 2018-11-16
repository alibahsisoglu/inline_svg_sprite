require "inline_svg_sprite/svg"

module InlineSvgSprite
  module ViewHelpers
    extend ActiveSupport::Concern

    def inline_svg_for(id, options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      output = capture(self, &block)
      options['id'] = id
      options['style'] = 'display:none;' unless options.has_key?('style')
      content_tag :svg, output, options
    end

    def svg(icon)
      svg_klass = InlineSvgSprite::Svg.new(icon)
      svg_klass.to_html.html_safe
    end
  end
end

ActiveSupport.on_load(:action_view) { include InlineSvgSprite::ViewHelpers }
