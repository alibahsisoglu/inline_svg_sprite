module InlineSvgSprite
  class Svg
    def initialize(icon)
      @icon = icon.include?('.svg') ? icon : "#{icon}.svg"
    end

    def to_html
      if exists?
        doc = Nokogiri::XML(open, &:noblanks)
        html = prepare(doc)
        html
      end
    end

    private

    def prepare(doc)
      doc = doc.remove_namespaces!.root
      doc.xpath("//comment()").remove
      doc.xpath("//*").each do |node|
        node.remove unless allowed_tags.include?(node.name)
      end      
      doc.xpath("//@id").remove
      doc.xpath('@*').each do |attribute|
        attribute.remove unless attribute.name == 'viewBox'
      end
      doc.name = 'symbol'
      doc["id"] = id
      doc.to_html
    end

    def id
      "#{InlineSvgSprite::Config.id_prefix}-#{File.basename(path, ".svg")}"
    end

    def exists?
      File.exists?(path)
    end

    def open
      File.open(path)
    end

    def path
      File.join(InlineSvgSprite::Config.svg_directory, @icon)
    end

    def allowed_tags
        %w(a altGlyph altGlyphDef altGlyphItem animate animateColor
           animateMotion animateTransform audio canvas circle clipPath
           color-profile cursor discard ellipse feBlend feColorMatrix
           feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting
           feDisplacementMap feDistantLight feDropShadow feFlood feFuncA
           feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode
           feMorphology feOffset fePointLight feSpecularLighting feSpotLight
           feTile feTurbulence filter font font-face font-face-format
           font-face-name font-face-src font-face-uri foreignObject g glyph
           glyphRef hatch hatchpath hkern iframe image line linearGradient
           marker mask mesh meshgradient meshpatch meshrow metadata
           missing-glyph mpath path pattern polygon polyline radialGradient
           rect script set solidcolor stop style svg switch symbol text
           textPath tref tspan unknown use video view vkern)
    end
  end
end