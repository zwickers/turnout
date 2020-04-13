class WelcomeController < ApplicationController
	def show
		render :layout => 'homepage'
		if current_user
			redirect_to "/classrooms"
		end
	end
	def enter
		
	end
end