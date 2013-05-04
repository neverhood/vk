module ApplicationHelper
  def page_header(text = t('.header'))
    "<div class='page-header'> <h3> #{ text } </h3> </div>".html_safe
  end

  def icon_label(classes, text = '')
    "<i class='#{ classes }'></i> #{ text }".html_safe
  end

  def dom_id(*args)
    super.dasherize
  end

  def vk_group_url group
    'http://vk.com/' + group.screen_name
  end

  def highlight_links text
  end
end
