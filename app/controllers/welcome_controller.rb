class WelcomeController < ApplicationController
	def show
		if current_user
			redirect_to "/classrooms"
		else
			render :layout => 'homepage'
		end
	end

	def enter
		
	end
end