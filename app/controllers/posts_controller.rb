class PostsController < ApplicationController

	before_action :authenticate_user!
	before_action :owned_post, only: [:edit, :update, :destroy]
	before_action :set_post, only: [:show, :edit, :destroy, :update]

	def index
		@posts = Post.all
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Your post has been created!"
			redirect_to posts_path
		else
			flash.now[:alert] = "Your new post couldn't be created! Please check the form!"
			render :new
		end
	end

	def show
	end

	def edit
	end

	def update
		if @post = Post.update(post_params)
			flash[:success] = "Your post has been updated!"
			redirect_to post_path(@post)
		else
			flash.now[:alert] = "Update failed. Please check the form!"
			render :edit
		end
	end

	def destroy
		@post.destroy
		redirect_to posts_path
	end

	private

	def post_params
		params.require(:post).permit(:image, :caption)
	end

	def comment_params
		params.require(:comment).permit(:content)
	end

	def set_post
		@post = Post.find(params[:id])
	end

	def owned_post
		unless current_user == @post.user
			flash[:alert] = "You're not allowed to view this page."
			redirect_to root_path
		end	
	end

end
