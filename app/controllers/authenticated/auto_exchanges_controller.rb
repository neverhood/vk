class Authenticated::AutoExchangesController < Authenticated::BaseController
  before_filter :find_group!

  def index
    @posts = current_user.posts.available_for_exchanges
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
