module Authenticated::AutoExchangesSearchesHelper
  def stored_condition attr
    @group.auto_exchange_conditions[attr.to_s] if @group.auto_exchange_conditions?
  end

  def sort_button attr
    link_to icon_label('', t(".sortings.#{attr}")), nil, class: 'btn', data: { sort_attribute: attr, sort_direction: 'desc' }
  end
end
