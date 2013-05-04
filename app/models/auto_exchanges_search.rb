class AutoExchangesSearch
  include Enumerable

  class << self
    def create params
      new(params).tap { |search| search.send(:fetch_results!) }
    end
  end

  attr_accessor :posts

  def initialize attrs
    @groups = Group.arel_table
    @posts = []

    attrs.each do |key, value|
      instance_variable_set :"@#{key}", value
      self.class.send :attr_accessor, key.to_sym
    end
  end

  def each &block
    fetch_results! unless @results.any?

    @results.each(&block)
  end

  private

  def fetch_results!
    groups = Group.all.select(:id).tap do |results|
      results.where!(conditions_for(:subscribers_count)) if processible_attributes?(:subscribers_count)
      results.where!(conditions_for(:views_count)) if processible_attributes?(:views_count)
      results.where!(conditions_for(:visitors_count)) if processible_attributes?(:visitors_count)
      results.where!(conditions_for(:reach)) if processible_attributes?(:reach)
      results.where!(conditions_for(:reach_subscribers)) if processible_attributes?(:reach_subscribers)
    end

    @posts = Post.where(available_for_exchanges: true, group_id: groups.pluck(:id)).includes(:group)
  end

  def processible_attributes? attr
    one_of_pair_attributes_present?(attr) and valid_pair?(attr)
  end

  def valid_pair? attr
    min, max = instance_variable_get(:"@min_#{attr}"), instance_variable_get(:"@max_#{attr}")
    return true if min.nil? or max.nil?

    if min >= max
      instance_variable_set :"@max_#{attr}", nil
      true
    end
  end

  def one_of_pair_attributes_present?(attr)
    instance_variable_get(:"@min_#{attr}").present? or instance_variable_get(:"@max_#{attr}").present?
  end

  def conditions_for attr
    min, max = instance_variable_get(:"@min_#{attr}"), instance_variable_get(:"@max_#{attr}")

    ( min.present? and max.present? ) ? _between(attr, min, max) : _resolve_pair(attr, min, max)
  end

  def _between attr, min, max
    { attr => [min..max] }
  end

  def _resolve_pair attr, min, max
    min.present?? @groups[attr].gteq(min) : @groups[attr].lteq(max)
  end
end

