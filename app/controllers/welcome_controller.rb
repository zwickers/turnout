class WelcomeController < ApplicationController
	def show
		if current_user
			redirect_to "/classes"
		end
	end
	def enter
		
	end
end