namespace :yokai do
  desc "センサーで監視"
  task watch: :environment do
    # 移動平均のサイズ
    BUFFER_SIZE = 5
    # 磁気、照度、温度それぞれの変化のしきい値
    SHOT_LINE = [50, 200, 5]
    # 取得間隔
    INTERVAL = 2

    # フラッシュ撮影
    def ghost_baster(light, trigger, human_val, magnetic_vol, lumen_vol, temp_vol)
      obs_at = Time.now
      #light = Light.new
      light.on
      # DB登録
      Discover.create(
        obs_at: obs_at,
        trigger: trigger,
        human: human_val,
        magnetic_vol: magnetic_vol,
        lumen_vol: lumen_vol,
        temp_vol: temp_vol
      )
      ##TODO 撮影
      `raspistill -o #{Rails.root}/public/photos/#{obs_at.strftime('%Y%m%d_%H%M%S')}.jpg`
      light.off
    end

    human = HumanCencer.new
    light = Light.new
    analog_cencers = [
      AnalogCencer.new(name: :magnetic, pin: 0, index: 0),
      AnalogCencer.new(name: :lumen,    pin: 1, index: 1),
      AnalogCencer.new(name: :temp,     pin: 2, index: 2)
    ]

    # 移動平均を算出するために、センサー数の空配列を作成
    buffers = []
    analog_cencers.size.times{ buffers << [] }

    while(true) do
      trigger = false

      # 人感センサー
      human.get
      if human.just_on?
        trigger = :human
      end

      # アナログセンサー
      analog_cencers.each_with_index do |cencer, i|
        # 電圧取得
        cencer.get_vol
        if buffers[i].size < BUFFER_SIZE
          buffers[i] << cencer.vol if cencer.vol
        else
          # 直近BUFFER_SIZEの平均
          avr = buffers[i].sum / buffers[i].size
          # 撮影判定
          if SHOT_LINE[i] < (avr - cencer.vol).abs
            puts "#{i}: #{avr - cencer.vol}"
            trigger ||= cencer.name
          end
          buffers[i].shift
          buffers[i] << cencer.vol
        end
      end

      # 判定
      if trigger
        Rails.logger.info 'Discover OBAKE!!'
        ghost_baster(light, trigger, human.value, *buffers.map(&:last))
        # バッファ初期化
        buffers = []
        analog_cencers.size.times{ buffers << [] }
        trigger = false
      end
      p buffers
      sleep INTERVAL
    end

  end
  task console: :environment do
    binding.pry
  end
end
