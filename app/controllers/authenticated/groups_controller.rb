class Authenticated::GroupsController < Authenticated::BaseController
  before_filter :find_group!, only: [ :show, :destroy ]

  def index
    @groups = current_user.groups
  end

  def show
  end

  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_path }
      format.json { render nothing: true, status: 202 }
    end
  end

  def update
    groups  = current_user_vk.groups.get(extended: 1, filter: 'admin').tap { |groups_list| groups_list.shift }

    groups.each do |group|
      group_attributes = group_params(group)

      if current_user.groups.where(vk_id: group_attributes[:vk_id]).any?
        current_user.groups.find_by(vk_id: group_attributes[:vk_id]).update group_attributes
      else
        current_user.groups.create(group_attributes)
      end
    end

    respond_to do |format|
      format.html { redirect_to groups_path, notice: I18n.t('flash.authenticated.groups.update.notice') }
      format.json do
        render json: { groups: render_to_string(partial: 'group', collection: current_user.groups), message: I18n.t('flash.authenticated.groups.update.notice') },
               status: 202
      end
    end
  end

  private

  def find_group!
    @group = Group.find(params[:id])
  end

  def group_params(attributes)
    { vk_id: attributes[:gid], name: attributes[:name], screen_name: attributes[:screen_name],
      photo_urls: attributes.slice(:photo, :photo_medium, :photo_big), group_type: attributes[:type],
      active: attributes[:is_closed].zero? }
  end
end
