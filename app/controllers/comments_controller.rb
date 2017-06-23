class CommentsController < ApplicationController

	def create
		@comment = Comment.new(comment_params)
		@comment.event_id = params[:event_id]
		respond_to do |format|
  		if @comment.save
        format.html{ redirect_to event_path(@comment.event) }
        format.js
  		end
    end
	end

	def comment_params
		params.require(:comment).permit(:user_name, :body)
	end
end
