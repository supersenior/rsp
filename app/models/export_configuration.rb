class ExportConfiguration
  include Virtus.model

  class Alignment
    include Virtus.model

    attribute :horizontal, Symbol # general, left, center, right, fill, justify, centerContinuous, distributed
    attribute :vertical, Symbol # top, center, bottom, justify, distributed
    attribute :text_rotation, Integer
    attribute :wrap_text, Boolean
    attribute :indent, Integer
    attribute :relative_indent, Integer
    attribute :justify_last_line, Boolean
    attribute :shrink_to_fit, Boolean
    attribute :reading_order, Integer # 0 Context Dependent, 1 Left-to-Right, 2 Right-to-Left
  end
  # alignment
  attribute :alignment, Alignment

  class BorderPr
    include Virtus.model

    attribute :style, Symbol # none, thin, medium, dashed, dotted, thick, double, hair, mediumDashed, dashDot
                             # mediumDashDot, dashDotDot, mediumDashDotDot, slantDashDot
    attribute :color, String
    attribute :name # start, end, left, right, top, bottom, diagonal, vertical, horizontal
  end

  class Border
    include Virtus.model

    attribute :diagonal_up, Boolean
    attribute :diagonal_down, Boolean
    attribute :outline, Boolean
    attribute :style, Symbol # none, thin, medium, dashed, dotted, thick, double, hair, mediumDashed, dashDot
                             # mediumDashDot, dashDotDot, mediumDashDotDot, slantDashDot
    attribute :color, String
    attribute :edges, Array[Symbol] # left, right, top, bottom
    attribute :border_left, BorderPr
    attribute :border_right, BorderPr
    attribute :border_top, BorderPr
    attribute :border_bottom, BorderPr
  end
  # border
  attribute :border, Border

  # float, integer, currency, percent, string, date, time
  # this is not axlsx configuration
  attribute :format, Symbol
  # refer axlsx gem for format_code to override default http://support.microsoft.com/kb/264372
  attribute :format_code, String

  CUSTOM_OPTIONS = {
    bg_color: String, fg_color: String, # background/text color,
    b: Boolean, u: Boolean, i: Boolean, strike: Boolean, shadow: Boolean, # bold/underline/italic/strike/shadow
    condense: Boolean, extend: Boolean, # condense/extend
    sz: Integer, outline: Integer, # font size/outline width,
    num_fmt: Integer, # 0~49
    charset: Integer, # 0 ANSI_CHARSET, 1 DEFAULT_CHARSET, 2 SYMBOL_CHARSET, 77 MAC_CHARSET, 128 SHIFTJIS_CHARSET
                      # 129 HANGUL_CHARSET, 130 JOHAB_CHARSET, 134 GB2312_CHARSET, 136 CHINESEBIG5_CHARSET
                      # 161 GREEK_CHARSET, 162 TURKISH_CHARSET, 163 VIETNAMESE_CHARSET, 177 HEBREW_CHARSET
                      # 178 ARABIC_CHARSET, 186 BALTIC_CHARSET, 204 RUSSIAN_CHARSET, 222 THAI_CHARSET
                      # 238 EASTEUROPE_CHARSET, 255 OEM_CHARSET
    family: Integer, # 0 Not applicable, 1 Roman, 2 Swiss, 3 Modern, 4 Script, 5 Decorative, 6..14 Reserved for future use
    font_name: String, hidden: Boolean, locked: Boolean, # font name/hidden/locked
    type: Symbol # [:dxf, :xf]. :xf is default
  }
  CUSTOM_OPTIONS.each do |option, type|
    attribute option, type
  end

  DEFAULT_FORMATS = {
    :currency => :integer,
    :percent => :float
  }

  DEFAULT_FORMAT_CODES = {
    :currency => '$#,##0',
    :percent => '0%',
    :float => '0.000'
  }

  def options
    @obj ||= self.dup
    @obj.format_code ||= DEFAULT_FORMAT_CODES[@obj.format]
    @obj.format = DEFAULT_FORMATS[@obj.format] || @obj.format
    if @obj.border
      @obj.border.style ||= :thin
      @obj.border.color ||= 'FF000000'
      (@obj.border.edges || [:left, :right, :top, :bottom]).each do |edge|
        @obj.border["border_#{edge}".to_sym] ||= BorderPr.new
        @obj.border["border_#{edge}".to_sym].name ||= edge
        @obj.border["border_#{edge}".to_sym].style ||= @obj.border.style
        @obj.border["border_#{edge}".to_sym].color ||= @obj.border.color
      end
    end

    @options ||= VirtusConvert.new(@obj, reject_nils: true).to_hash
  end

  def self.dump(config)
    VirtusConvert.new(config, reject_nils: true).to_hash
  end

  def self.load(config)
    new(config)
  end
end