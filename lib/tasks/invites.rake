namespace :invites do
  task :generate => :environment do
    for i in 0..100
      code = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
      Invitation.create(:invite_code=>code)
    end
  end
end