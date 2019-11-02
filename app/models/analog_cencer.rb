class AnalogCencer
  attr_reader :name, :pin, :index, :vol, :change_rate, :first_vol

  # 初期化
  def initialize(attrs={})
    @name  = attrs[:name]
    @pin   = attrs[:pin]
    @index = attrs[:index]
  end

  # 電圧を取得
  def get_vol
    ##TODO
    self.vol= 2500 + (-250..250).to_a.sample
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