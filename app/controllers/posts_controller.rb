class PostsController < ApplicationController
	 load_and_authorize_resource
	before_action :find_post, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!,except: [:index,:show]



	
	def index
		@posts = Post.all.order("created_at DESC")
	end

	def show
        @post = Post.find(params[:id])
    end

	def new 
		@post = current_user.posts.new
	end

	def create
		@post = current_user.posts.new(post_params)
		 #post.image.attach(params[:post][:image])

		if @post.save
			redirect_to @post, notice: "yess It is posted"
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to @post ,  notice: "Congrats its updated"
		else
			render 'edit'
		end
	end

	def destroy
		@post.comments.each do |d| 
			d.destroy
		end	
		@post.destroy
		redirect_to root_path
	end


	private

	def find_post
		@post = Post.find(params[:id])
	end



	def post_params
		params.require(:post).permit(:title, :description , :image)
	end
end
