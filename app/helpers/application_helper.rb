module ApplicationHelper
	def full_title(page_title)
		base_tiltle="Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_tiltle
		else
			"#{base_tiltle} | #{page_title}"
		end
	end
	
end
