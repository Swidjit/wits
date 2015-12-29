class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :game_board
  has_many :reactions, :dependent => :delete_all
  has_many :flag_votes
  has_many :awards, :dependent => :delete_all


  validates_presence_of :body, :game_board_id, :user_id
  validates_uniqueness_of :user_id, scope: :game_board_id, :message => "you have already submitted an entry for this game"

  acts_as_commentable
  acts_as_taggable

  default_scope { Post.where("posts.status = 'published'") }
  scope :recent, lambda{  Post.joins(:game_board).where("#{GameBoard.table_name}.end_date > ?", Time.now-48.hours) }
  scope :top_yesterday, lambda{  Post.joins(:game_board).where("#{GameBoard.table_name}.end_date > ?", Time.now-24.hours).order("score desc") }
  scope :top_this_week, lambda{  Post.joins(:game_board).where("#{GameBoard.table_name}.end_date > ?", Time.now-7.days).order("score desc") }
  scope :top_this_month, lambda{  Post.joins(:game_board).where("#{GameBoard.table_name}.end_date > ?", Time.now-1.month).order("score desc") }
  scope :top_this_year, lambda{  Post.joins(:game_board).where("#{GameBoard.table_name}.end_date > ?", Time.now-1.year).order("score desc") }

  validate :no_bad_words, :follows_game_rules


  def no_bad_words
    words = self.body.split(" ")
    #lets take out punctuation
    bad_words = ["damn","crap"]
    intersection = words & bad_words.to_a

    if intersection.length > 0
      errors.add(:body, "your post contains a restricted word")
    end
  end

  def follows_game_rules
    words = self.body.split(" ")
    case self.game_board.game.id
      when 1
        if self.body.length >= (self.game_board.content_limit || self.game_board.game.content_limit)
          errors.add(:body, "your post is too long")
        end
      #answer
      when 2
        game_words = self.game_board.data.split(",")
        if (words - game_words).length > 3
          errors.add(:body, "you used too many of your own words")
        end
      #aphorisms
      when 3
        if self.body.length >= (self.game_board.content_limit || self.game_board.game.content_limit)
          errors.add(:body, "your post is too long")
        end
      #acronym
      when 4
        letters = self.game_board.content.split("")
        if letters.size == words.size
          letters.each_with_index do |l,key|
            if l.downcase != words[key][0].downcase
              errors.add(:body, "you have not submitted a valid acronym (#{words[key]})")
            end
          end
        else
          errors.add(:body, "your entry is not the right length")
        end

      when 5
        taboo_words = self.game_board.data.split(",")
        if(words - taboo_words).length < words.size
          errors.add(:body, "your entry uses one of the taboo words")
        end
      #almost blank
      when 6
        letters = self.game_board.data.split(',')
        words.each do |w|
          if w[0].downcase != letters.shift.downcase
            errors.add(:body, "your first word letters do not match the puzzle")
          end
        end
      #allitery
      when 7
        first_word = words[0]
        first_letter = first_word[0]
        words.each do |w|
          if w[0].downcase != first_letter.downcase
            errors.add(:body, "all your words must begin with the same letter")
          end
        end
      #rename
      when 8
        if words.size == 1

        else
          errors.add(:body, "your entry is too long. one word only")
        end
     end
  end
  def read_attribute_for_validation(attr)
    send(attr)
  end

  def Post.human_attribute_name(attr, options = {})
    attr
  end

  def Post.lookup_ancestors
    [self]
  end
end
