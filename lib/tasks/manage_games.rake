namespace :games do

  desc "check for expired games"
  task :check_expired => :environment do
    @boards = GameBoard.active
    @boards.each do |b|
      if b.start_date + b.duration.hours < Time.now
        b.update_attribute(:status,"expired")
        b.update_attribute(:end_date,Time.now)
        Post.unscoped.where(:game_board_id => b.id).update_all(:status => 'published')
        new_board = GameBoard.where(:game_id => b.game_id, :status => "queued").first
        if new_board
          new_board.update_attribute(:status,"active")
          new_board.update_attribute(:start_date,Time.now)
        end
      end
      #update times_played for games
      b.game.update_attribute(:times_played,b.game.times_played + b.posts.size)
      #calculaye avg_times_played
    end



  end


  desc "give out awards"
  task :give_awards => :environment do
    Award.delete_all
    @boards = GameBoard.expired
    @boards.each do |b|
      #post_count = b.posts.size/10.floor
      post_count = b.posts.size/10.floor > 10 ? b.posts.size/10.floor : 10
      posts = b.posts.order('score desc').limit(post_count)
      if posts.first
        posts.each_with_index do |p, k|
          if k==0
            Award.create(:user => p.user, :post => p, :board_id => b.id, :award_type => "winner")
          elsif k < 10
            Award.create(:user => p.user, :post => p, :board_id => b.id, :award_type => "top10")
          else
            Award.create(:user => p.user, :post => p, :board_id => b.id, :award_type => "top10pct")
          end
        end
      end
    end
  end
end