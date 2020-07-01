helpers do
  def markdown(text)
    render_options = {
      filter_html: true,
      hard_wrap:   true
    }
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
      autolink:            true,
      fenced_code_blocks:  true,
      lax_spacing:         true,
      no_intra_emphasis:   true,
      strikethrough:       true,
      superscript:         true,
      tables:              true,
      space_after_headers: true
    }

    Redcarpet::Markdown.new(renderer, extensions).render(text)
  end
end
