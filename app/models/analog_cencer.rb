class AnalogCencer
  attr_reader :name, :pin, :index, :vol, :change_rate, :first_vol

  # 初期化
  def initialize(attrs={})
    @name  = attrs[:name]
    @pin   = attrs[:pin]
    @index = attrs[:index]
    `i2cset -y 1 0x48 1 0xC385 w`
  end

  # 電圧を取得
  def get_vol
    #self.vol= 2500 + (-500..500).to_a.sample
    #puts @pin
    self.vol= (`node ./node/index.js #{@pin}`.split("\n")[2].to_f * 1000 ).to_i
  end

  # 初回読込値をインスタンスに格納
  def vol=(mv)
    @vol = mv
    if @first_vol
      @change_rate = @first_vol / @vol.to_f
    else
      @first_vol = @vol
    end
  end
end
