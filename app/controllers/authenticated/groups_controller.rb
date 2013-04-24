class Authenticated::GroupsController < Authenticated::BaseController
  before_filter :find_group!, only: [ :show, :destroy ]

  def index
    @groups = current_user.groups
  end

  def show
  end

  def destroy
  end

  def update
  end

  private

  def find_group!
    @group = Group.find(params[:id])
  end
end
