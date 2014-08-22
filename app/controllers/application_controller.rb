class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	#默认情况下。app/helpers/*的函数只能使用在view中。
	# 但是include到applicateion_controller中，就可以了正常使用了。
	include SessionsHelper 
end
