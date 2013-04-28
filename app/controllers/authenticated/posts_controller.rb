class Authenticated::PostsController < ApplicationController
  before_filter :find_post!, only: [ :show, :update, :destroy ]
  before_filter :find_group!, only: [ :create ]
  before_filter :validate_photo_ids!, only: [ :create, :update ]

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
    params.require(:post).permit(:body, :group_id, :from_group, photo_ids: [])
  end

  def edit_post_params # needed because we have both 'new' and 'edit' forms on the same page
    params.require(:edit_post).permit(:body, :from_group, photo_ids: [])
  end

  def validate_photo_ids!
    if params[:post].present?
      params[:post][:photo_ids] = _validated_photo_ids(params[:post][:photo_ids])
    elsif params[:edit_post].present?
      params[:edit_post][:photo_ids] = _validated_photo_ids(params[:edit_post][:photo_ids])
    end
  end

  def _validated_photo_ids id_list
    current_user.photos.select('photos.id').where(id: id_list.split(',').map(&:to_i).uniq).pluck(:id)
  end
end
