class Authenticated::AutoExchangesSearchesController < Authenticated::BaseController
  before_filter :find_group!

  def new
    @posts = current_user.posts.available_for_exchanges
  end

  def create
    @group.update auto_exchange_conditions: auto_exchanges_search_params
    @auto_exchanges_search = AutoExchangesSearch.create(auto_exchanges_search_params, order)

    render json: { results: render_to_string(partial: 'auto_exchanges_search', collection: @auto_exchanges_search.posts, as: 'post') }
  end

  private

  def find_group!
    @group = current_user.groups.find(params[:group_id])
  end

  def auto_exchanges_search_params
    params.require(:auto_exchanges_search).permit(:min_subscribers_count, :max_subscribers_count, :min_views_count, :max_views_count,
                                                  :min_visitors_count, :max_visitors_count, :min_reach, :max_reach,
                                                  :min_subscribers_reach, :max_subscribers_reach).

                                                  delete_if { |key, value| value.to_i < 1 }
  end

  def auto_exchanges_search_sort_params
    params.require(:auto_exchanges_search).permit(:sort_attribute, :sort_direction).tap do |attrs|
      attrs[:sort_attribute] = nil unless AutoExchangesSearch.sortable_attributes.include?(attrs[:sort_attribute])
      attrs[:sort_direction] = nil unless AutoExchangesSearch.sortable_directions.include?(attrs[:sort_direction])
    end
  end

  def order
    attrs = auto_exchanges_search_sort_params
    return nil unless attrs[:sort_attribute].present? and attrs[:sort_direction].present?

    "groups.#{ attrs[:sort_attribute] } #{ attrs[:sort_direction] }"
  end
end
