namespace :check_code do
  desc "TODO"
  task check_now: :environment do
    Website.all.each do |website|
      url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url
      Rails.logger.info "Checking the HTML code for the URL -- #{url}"
      doc = Nokogiri::HTML(open(url).read)
      Rails.logger.info "*****************************************"
      if doc
        Rails.logger.info "#{url} has content!"
      else
        Rails.logger.info "\n\n\n#{url} has no content!"
      end
      #if (website.content != doc.to_html)
        # Rails.logger.info "#{url} content differ now!!!!!!!!!!!\n\n\n"
        if website.content.present?
          Gastly.capture(url, "public/assets/screenshots/#{website.id}_change.png")
          cmp = Imatcher::Matcher.new
          res = cmp.compare("public/assets/screenshots/#{website.id}.png", "public/assets/screenshots/#{website.id}_change.png") 
          if !res.match?
            res.difference_image.save("public/assets/screenshots/#{website.id}_diff.png")
          end
          diff = Differ.diff_by_word(website.content, doc.to_html)
          email = website.subscriber.email
          NotificationMailer.send_mail(email, website.url, diff).deliver if website.content != doc.to_html
          Gastly.capture(url, "public/assets/screenshots/#{website.id}.png")
          website.content = doc.to_html
          website.save!
        else
          website.content = Nokogiri::HTML(open(url).read).to_html
        end
      # else
      #  Rails.logger.info "No difference in #{url}. Going on\n"
      # end
    end
  end
end