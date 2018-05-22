class PagesController < ApplicationController
	def index
		redirect_to microposts_path if logged_in?
	end

end	