# coding: utf-8
class Discover < ApplicationRecord
  enum trigger: {human: 0, magnetic: 1, lumen: 2, temp: 3}

  validates :obs_at, presence: true
  validates :trigger, presence: true
  validates :magnetic_vol, presence: true
  validates :lumen_vol, presence: true
  validates :temp_vol, presence: true

  class Search
    include ActiveModel::Model
    include ActiveModelBase

    attr_accessor :obs_at_from, :obs_at_to, :triggers, :magnetic_vol_from, :magnetic_vol_to, :lumen_vol_from, :lumen_vol_to, :temp_vol_from, :temp_vol_to, :human
         type_int :magnetic_vol_from, :magnetic_vol_to, :lumen_vol_from, :lumen_vol_to, :temp_vol_from, :temp_vol_to
        type_bool :human

    def search(page)
      model = Discover.active.order(id: :desc)

      model = model.between(:obs_at, self.obs_at_from, self.obs_at_to)

      self.triggers.try :delete, ""
      if self.triggers.present?
        model = model.where(trigger: self.triggers)
      end

      if self.human.present?
        model = model.where(human: self.human )
      end

      model = model.between(:magnetic_vol, self.magnetic_vol_from, self.magnetic_vol_to)

      model = model.between(:lumen_vol, self.lumen_vol_from, self.lumen_vol_to)

      model = model.between(:temp_vol, self.temp_vol_from, self.temp_vol_to)

      model.page(page)
    end
  end
end
