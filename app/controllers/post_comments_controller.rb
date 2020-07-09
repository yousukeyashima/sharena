class PostCommentsController < ApplicationController

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
end
