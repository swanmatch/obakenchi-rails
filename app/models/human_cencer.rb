# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class HumanCencer
  attr_reader :value, :last_value

  def initialize
  end

  def get
    ##TODO
    @last_value = value
    @value = [0,0,0,0,0,0,0,0,0,1].sample
  end

  def just_on?
    @last_value == 0 && @value == 1
  end
end
