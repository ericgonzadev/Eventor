class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.event_id = params[:event_id]
    respond_to do |format|
      if @comment.save
        format.html{ redirect_to event_path(@comment.event) }
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html{ redirect_to event_path(@comment.event) }
      format.js
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
