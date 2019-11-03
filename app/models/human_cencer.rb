# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class HumanCencer
  attr_reader :value, :last_value

  def initialize
    @gpio = PiPiper::Pin.new(pin: 5, direction: :in)
  end

  def get
    @last_value = @value
    @value = @gpio.read
  end

  def just_on?
    @last_value == 0 && @value == 1
  end
end
