module CaptureScreenshot
	def self.capture url, name 
		screenshot = Gastly.screenshot(url, timeout: 3000)
    	image = screenshot.capture
    	image.save("public/assets/screenshots/#{name}.png")
    # ImageOptimizer.new("public/assets/screenshots/#{name}.png", level: 1).optimize
	end
end

# CaptureScreenshot.capture("http://www.freshcaller.com", "test")