defmodule CachingWeb.PageHTML do
  use CachingWeb, :html

  embed_templates "page_html/*"
end
