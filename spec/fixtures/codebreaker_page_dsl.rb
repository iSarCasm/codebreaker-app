module CodebreakerPageDSL
  def state
    page.first('.state').text
  end

  def hints_left
    page.first('#hints_left').text.to_i
  end

  def attempts_left
    page.first('#attempts_left').text.to_i
  end

  def last_response
    page.first('#last_response').text
  end

  def last_hint
    last_response[/\d/].to_i
  end

  def last_hint_position
    last_response.scan(/.+\d/).first.scan(/\*/).size
  end

  def submit_code(code)
    fill_in 'code', with: code.join
    click_button 'Submit'
  end

  def find_out_correct_code
    3.times.with_object([]) do |i, code|
      click_link 'Hint!'
      code[last_hint_position] = last_hint
    end
  end

  def find_out_wrong_code
    wrong_code = find_out_correct_code
    wrong_code.map! do |e|
      ((e + 1) % 7 == 0 ? 1 : (e + 1) % 7)
    end
  end
end
