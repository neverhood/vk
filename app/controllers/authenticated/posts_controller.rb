class Authenticated::PostsController < Authenticated::BaseController
  before_filter :find_post!, only: [ :update, :destroy ]
  before_filter :find_group!, only: [ :index, :create ]
  before_filter :validate_photo_ids!, only: [ :create, :update ], unless: -> { repost? }

  def index
    @posts  = @group.posts.page(params[:page])
    @photos = current_user.photos.all
    @post   = @group.posts.new
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
      if @post.update post_params
        format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.posts.update.notice') }
        format.json { render json: { entry: render_to_string(partial: 'post', locals: { post: @post }), id: @post.id }, status: 202 }
      else
        format.html { redirect_to group_path(@post.group), notice: I18n.t('flash.authenticated.posts.update.alert') }
        format.json { render json: { errors: @post.errors }, status: 422 }
      end
    end
  end

  def create
    if repost?
      if valid_repost?
        @post = @group.posts.create(repost_params)
      else
        @post = Post.new.tap { |post| post.errors.add(:vk_details, I18n.t('activerecord.errors.models.post.attributes.vk_details.invalid')) }
      end
    else
      @post = @group.posts.create(post_params)
    end

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
    @group = if action_name == 'index'
               current_user.groups.find(params[:id])
             else
               current_user.groups.find(post_params[:group_id])
             end
  end

  def post_params
    if params[:post].present?
      params.require(:post).permit(:body, :group_id, :from_group, photo_ids: [])
    else
      params.permit(:available_for_exchanges)
    end
  end

  def repost_params
    params.require(:post).permit(:vk_details, :body).tap do |attributes|
      wall_id, post_id = attributes[:vk_details].scan(/\d+_\d+/).last.split('_')

      attributes[:vk_details] = { url: attributes[:vk_details], wall_id: wall_id, post_id: post_id }
      attributes[:repost]             = true
    end
  end

  def repost?
    params[:post].present? and params[:post][:repost] == 'true'
  end

  def valid_repost?
    params[:post].try(:[], :vk_details) =~ /\d+_\d+/
  end

  def validate_photo_ids!
    return if params[:post].try(:[], :photo_ids).nil?

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
