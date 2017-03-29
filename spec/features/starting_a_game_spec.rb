require 'spec_helper'

RSpec.describe 'starting a game', type: :feature, js: true do
  it 'starts a new game from home page' do
    visit 'localhost:9292/'
    select 'Easy', from: 'diff'
    click_button 'Play'

    expect(current_path).to eq '/play'
    expect(page).to have_content 'Description'
    expect(page).to have_content 'State'
    expect(page).to have_content 'Guessing'
  end
end
