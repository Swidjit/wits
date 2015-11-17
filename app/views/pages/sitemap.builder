xml.instruct!
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do

  xml.url{
      xml.loc(root_url)
      xml.changefreq("daily")
      xml.priority(1.0)
  }

  User.all.each do |user|
	  xml.url{
	      xml.loc(user_url(user))
	      xml.changefreq("weekly")
	      xml.priority(0.5)
	  }

  end

end
