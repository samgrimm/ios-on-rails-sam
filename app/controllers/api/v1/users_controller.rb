class Api::V1::UsersController < ApiController

	def create
		@user = User.new

    	if @user.save
      		render
    	else
      	render json: {
        	message: 'Validation Failed',
        	errors: @user.errors.full_messages
      	}, status: 422
    	end
	end
end