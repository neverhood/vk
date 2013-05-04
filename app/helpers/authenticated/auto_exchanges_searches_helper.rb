module Authenticated::AutoExchangesSearchesHelper
  def stored_condition attr
    @group.auto_exchange_conditions[attr.to_s] if @group.auto_exchange_conditions?
  end
end
