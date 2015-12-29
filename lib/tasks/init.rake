namespace :init do

  task :add_tags => :environment do
    ActsAsTaggableOn::Tag.create(:name => "")
  end

  task :seed_games => :environment do
    Game.create(:title=>'Sentenced', :description=>'Say something using all of these words.',:content_limit=>500)
    Game.create(:title=>'Answer', :description=>'Respond to the question however you want',:content_limit=>250)
    Game.create(:title=>'Aphorisms', :description=>'Coin a new expression.',:content_limit=>140)
    Game.create(:title=>'Acronyms', :description=>'Make an ordinary word into an acronym',:content_limit=>0)
    Game.create(:title=>'Tabooed', :description=>'Describe something without using the tabooed words',:content_limit=>250)
    Game.create(:title=>'Almost Blank', :description=>'Say anything using these letters as a guide',:content_limit=>0)
    Game.create(:title=>'Alliterary', :description=>'Answer using words with same first letter',:content_limit=>0)
    Game.create(:title=>'Rename', :description=>'Make this object human',:content_limit=>0)
    Game.create(:title=>'Captioned', :description=>'Provide a caption for this photo',:content_limit=>0)

  end

end