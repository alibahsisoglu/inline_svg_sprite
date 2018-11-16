require "inline_svg_sprite/version"
require "inline_svg_sprite/config"
require "inline_svg_sprite/view_helpers"

module InlineSvgSprite
  class Engine < ::Rails::Engine
    def initialize
      super
      Config.svg_directory = ::Rails.root.join('app', 'assets', 'svg')
      Config.id_prefix = 'icon'
    end
  end
end
