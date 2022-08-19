class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit update destroy]
  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)

    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy

    redirect_to root_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
