# coding: utf-8
class DiscoversController < ApplicationController
  before_action :set_discover, only: [:show, :edit, :update, :destroy]

  # GET /discovers
  def index
    @search_discover = Discover::Search.new(search_params)
    @discovers = @search_discover.search(params[:page])
  end

  # GET /discovers/1
  def show
  end

  # GET /discovers/new
  def new
    @discover = Discover.new
  end

  # GET /discovers/1/edit
  def edit
  end

  # POST /discovers
  def create
    @discover = Discover.new(discover_params)

    if @discover.save
      redirect_to @discover, notice: 'Discover was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /discovers/1
  def update
    if @discover.update(discover_params)
      redirect_to @discover, notice: 'Discover was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /discovers/1
  def destroy
    @discover.logical_delete!
    redirect_to discovers_url, notice: 'Discover was successfully destroyed.'
  end

  private
    # Search params
    def search_params
      if params[:discover_search]
        params.require(:discover_search).permit(:obs_at_from, :obs_at_to, {triggers: []}, :magnetic_vol_from, :magnetic_vol_to, :lumen_vol_from, :lumen_vol_to, :temp_vol_from, :temp_vol_to, :human)
      else
        {}
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_discover
      @discover = Discover.active.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def discover_params
      params.require(:discover).permit(:obs_at, :trigger, :human, :magnetic_vol, :lumen_vol, :temp_vol, :lock_version)
    end
end
