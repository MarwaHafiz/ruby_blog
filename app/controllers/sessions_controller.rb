class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:session][:email])

        if user 
          session[:user_id] = user.id
          redirect_to user
        end
      end
    def destroy
        session.delete(:user_id)
        @current_user = nil
        render 'new'
    end
end
