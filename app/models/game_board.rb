class GameBoard < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :game
  has_many :players, :foreign_key => 'user_id', :class_name => "User"
  has_many :posts, :dependent => :delete_all
  has_many :votes,:as => :voteable, :dependent => :delete_all

  after_save :stats, if: :status_changed?
  # has_many :results

  serialize :content

  scope :active, lambda{ where("#{table_name}.status = ?","active")}
  scope :expired, lambda{ where("#{table_name}.status = ?", "expired")}

  def stats
    if self.status=='expired'
      total = self.posts.sum(:score)
      self.posts.each do |p|
        pct = p.score/total.to_f
        game_stat = GameStat.where(:user_id => p.user.id, :game_id => self.game_id).first
        if game_stat

          pct_num = (game_stat.pct*game_stat.board_count )
          game_stat.board_count += 1
          new_pct = (pct_num+pct)/game_stat.board_count

          game_stat.pct = new_pct
          game_stat.score += p.score
          game_stat.score_avg = game_stat.score/game_stat.board_count.to_f
          game_stat.save
        else
          GameStat.create(:user_id => p.user.id, :game_id => self.game_id, :pct=>pct, :score=>p.score,:score_avg=>p.score,:board_count=>1)
        end
      end
    end
  end

  def create

  end

  private

  def board_params
    params.require(:game_board).permit(:game_id, :content, :data)
  end


end
