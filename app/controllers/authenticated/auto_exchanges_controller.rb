class Authenticated::AutoExchangesController < Authenticated::BaseController
  before_filter :find_group!

  def index
  end

  def create
  end

  def update
  end

  private

  def find_group!
    @group = current_user.groups.find(params[:group_id])
  end
end
