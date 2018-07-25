namespace :check_code do
  desc "TODO"
  task check_now: :environment do
    time = Time.now
    Rails.logger.info "Rake task started at #{time}"
    Website.all.each do |website|
      if website.priority
        url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url
        Rails.logger.info "Checking the HTML code for the URL -- #{url}"
        doc = Nokogiri::HTML(open(url).read)
        Rails.logger.info "*****************************************"
        if doc
          Rails.logger.info "#{url} has content!"
        else
          Rails.logger.info "\n\n\n#{url} has no content!"
        end
        if website.content.present?
          screenshot = Gastly.screenshot(url, timeout: 3000)
          image = screenshot.capture
          image.save("public/assets/screenshots/#{website.id}_change.png")
          ImageOptimizer.new("public/assets/screenshots/#{website.id}_change.png", level: 3).optimize
          website.update_attributes!(new_time: Time.now)
          cmp = Imatcher::Matcher.new
          begin
            res = cmp.compare("public/assets/screenshots/#{website.id}.png", "public/assets/screenshots/#{website.id}_change.png")
            website.update_attributes!(diff_time: Time.now)
            if res.match?
              Rails.logger.info "#{website.url} screenshots match! \n\n\n"
            else
              website.update_attributes!(was_updated: true)
              Rails.logger.info "!!!!! #{website.url} screenshots do not match!!!!!! \n\n\n"
              base_image = Magick::Image.read("public/assets/screenshots/#{website.id}_change.png").first
              gc = Magick::Draw.new
              gc.fill_opacity(0)
              gc.stroke_width(5)
              gc.stroke('blue')
              gc.rectangle(res.mode.bounds.left + 10, res.mode.bounds.top + 10, res.mode.bounds.right - 10, res.mode.bounds.bot - 10)
              gc.fill('white')
              gc.draw(base_image)
              base_image.write("public/assets/screenshots/#{website.id}_diff.png")
              # res.difference_image.save("public/assets/screenshots/#{website.id}_diff.png")
            end
          rescue
            Rails.logger.info "********************************* Inside Rescue ***************************************"
            screenshot = Gastly.screenshot(url, timeout: 3000)
            image = screenshot.capture
            image.save("public/assets/screenshots/#{website.id}.png")
            ImageOptimizer.new("public/assets/screenshots/#{website.id}.png", level: 3).optimize
            website.update_attributes!(old_time: Time.now)
          end
          diff = Differ.diff_by_word(website.content, doc.to_html)
          email = website.user.email
          #if (website.content != doc.to_html) or (!res.match?)
          if !res.match?
            # NotificationMailer.send_mail(email, website.url, diff).deliver
            NotificationMailer.send_mail(email, website.url, website.id).deliver
          end
          screenshot = Gastly.screenshot(url, timeout: 3000)
          image = screenshot.capture
          image.save("public/assets/screenshots/#{website.id}.png")
          ImageOptimizer.new("public/assets/screenshots/#{website.id}.png", level: 3).optimize
          website.update_attributes!(old_time: Time.now)
          website.content = doc.to_html
          website.save!
        else
          website.content = Nokogiri::HTML(open(url).read).to_html
        end
      else
        Rails.logger.info "Tracking has been paused for the website #{website.url}"
      end
    end
    end_time = Time.now
    Rails.logger.info "Rake task ended at #{end_time}"
    Rails.logger.info "Total time taken = #{end_time - time}\n\n"
  end

  task check_seven: :environment do
    Website.all.each do |website|
      url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url
      if !File.file?("public/assets/screenshots/#{website.id}_report_two.png") and !File.file?("public/assets/screenshots/#{website.id}_report_three.png")
        website.report_two = Time.now
        website.save!
        Rails.logger.info "Taking the 7th day screenshot for the website - #{website}"
        screenshot = Gastly.screenshot(url, timeout: 3000)
        image = screenshot.capture
        image.save("public/assets/screenshots/#{website.id}_report_two.png")
        ImageOptimizer.new("public/assets/screenshots/#{website.id}_report_two.png", level: 3).optimize
        Rails.logger.info "Done with the 7th day screenshot for the website - #{website}"
      elsif File.file?("public/assets/screenshots/#{website.id}_report_two.png") and !File.file?("public/assets/screenshots/#{website.id}_report_three.png")
        Rails.logger.info "Taking the 14th day screenshot for the website - #{website}"
        website.report_three = Time.now
        website.save!
        screenshot = Gastly.screenshot(url, timeout: 3000)
        image = screenshot.capture
        image.save("public/assets/screenshots/#{website.id}_report_three.png")
        ImageOptimizer.new("public/assets/screenshots/#{website.id}_report_three.png", level: 3).optimize
        Rails.logger.info "Done with the 14th day screenshot for the website - #{website}"
      elsif File.file?("public/assets/screenshots/#{website.id}_report_two.png") and File.file?("public/assets/screenshots/#{website.id}_report_three.png")
        Rails.logger.info "Taking the 14th day screenshot for the website - #{website} and replacing the first day screenshot"
        File.delete("public/assets/screenshots/#{website.id}_report_one.png")
        File.rename("public/assets/screenshots/#{website.id}_report_two.png", "public/assets/screenshots/#{website.id}_report_one.png")
        File.rename("public/assets/screenshots/#{website.id}_report_three.png", "public/assets/screenshots/#{website.id}_report_two.png")
        website.report_one = website.report_two
        website.report_two = website.report_three
        website.report_three = Time.now
        website.save!
        screenshot = Gastly.screenshot(url, timeout: 3000)
        image = screenshot.capture
        image.save("public/assets/screenshots/#{website.id}_report_three.png")
        ImageOptimizer.new("public/assets/screenshots/#{website.id}_report_three.png", level: 3).optimize
        Rails.logger.info "Done with replacing and taking the new screenshots"
      end
    end
  end
end