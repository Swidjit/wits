class StatsController < ApplicationController

  def index
    case params[:type]
      when 'overall'
        @top_players = User.order("score desc")
        @top_posts = Post.order("score desc")
      when 'yesterday'
        @top_posts = Post.top_yesterday

        user_scores = Hash.new
        @top_posts.each do |p|
          user_scores[p.user.id] == nil ? user_scores[p.user_id] = p.score : user_scores[p.user_id] += p.score
        end
        user_scores.sort_by { |id, score| score }
        ids = user_scores.keys[0..50]
        @top_scores = user_scores.values[0..50]
        @top_players = User.find(ids)
      when 'week'
        @top_posts = Post.top_this_week

        user_scores = Hash.new
        @top_posts.each do |p|
          user_scores[p.user.id] == nil ? user_scores[p.user_id] = p.score : user_scores[p.user_id] += p.score
        end
        user_scores.sort_by { |id, score| score }
        ids = user_scores.keys[0..50]
        @top_scores = user_scores.values[0..50]
        @top_players = User.find(ids)
      when 'month'
        @top_posts = Post.top_this_month

        user_scores = Hash.new
        @top_posts.each do |p|
          user_scores[p.user.id] == nil ? user_scores[p.user_id] = p.score : user_scores[p.user_id] += p.score
        end
        user_scores.sort_by { |id, score| score }
        ids = user_scores.keys[0..50]
        @top_scores = user_scores.values[0..50]
        @top_players = User.find(ids)
    end
  end


end
