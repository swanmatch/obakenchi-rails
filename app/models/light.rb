# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Light
  def initialize
    @gpio = PiPiper::Pin.new(pin: 6, direction: :out)
  end

  def on
    puts 'LED ON!!!'
    @gpio.on
  end
  def off
    puts 'LED off...'
    @gpio.off
  end
end
