module CodebreakerPageTags
  def page_play_state
    page.first('.state').text
  end

  def page_play_hints_left
    page.first('#hints_left').text.to_i
  end

  def page_play_attempts_left
    page.first('#attempts_left').text.to_i
  end
end
