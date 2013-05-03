module Authenticated::PostsHelper
  def repost_content(post)
    "<span class='label label-info'>#{ t('.repost_from') }</span>: #{post.vk_details['url']}".html_safe
  end
end
