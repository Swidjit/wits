class StatsController < ApplicationController

  def index
    params[:scope]=8 if !params.has_key?(:scope)
    params[:duration]=1 if !params.has_key?(:duration)
    params[:order] = 'pct' if !params.has_key?(:order)
    if params[:duration].to_i > 0
      @stats = GameStat.where(:game_id=>params[:scope]).where('created_at > ?',Time.now-params[:duration].to_i.days).order(params[:order] +' DESC')
    else
      @stats = GameStat.where(:game_id=>params[:scope]).order(params[:order] +' DESC')
    end
    @sort_class=params[:order]
    if request.xhr?
      render 'load'
    end
  end

end
