class Authenticated::PostsController < ApplicationController
  before_filter :find_post!, only: [ :show, :update, :destroy ]
  before_filter :find_group!, only: [ :create ]

  def show
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.posts.destroy.notice') }
      format.json { render nothing: true, status: 202 }
    end
  end

  def update
    respond_to do |format|
      if @post.update edit_post_params
        format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.posts.update.notice') }
        format.json { render json: { entry: render_to_string(partial: 'post', locals: { post: @post }), id: @post.id }, status: 202 }
      else
        format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.posts.update.alert') }
        format.json { render json: { errors: @post.errors }, status: 422 }
      end
    end
  end

  def create
    @post = @group.posts.create(post_params)

    respond_to do |format|
      if @post.persisted?
        format.html { redirect_to group_path(@group), notice: I18n.t('flash.authenticated.posts.create.notice') }
        format.json { render json: { entry: render_to_string(partial: 'post', locals: { post: @post }) }, status: 202 }
      else
        format.html { redirect_to group_path(@group), notice: I18n.t('flash.authenticated.posts.create.alert') }
        format.json { render json: { errors: @post.errors }, status: 422 }
      end
    end
  end

  private

  def find_post!
    @post = current_user.posts.find(params[:id])
  end

  def find_group!
    @group = current_user.groups.find(post_params[:group_id])
  end

  def post_params
    params.require(:post).permit(:body, :group_id)
  end

  def edit_post_params # needed because we have both 'new' and 'edit' forms on the same page
    params.require(:edit_post).permit(:body)
  end
end
