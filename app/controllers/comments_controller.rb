class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@comment.event_id = params[:event_id]
		@comment.save ? flash[:success] = "Comment posted" : flash[:danger] = "Comment cannot be empty"
		redirect_to event_path(@comment.event)
	end

	def comment_params
		params.require(:comment).permit(:user_name, :body)
	end
end
