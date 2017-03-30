require 'spec_helper'

RSpec.describe 'losing a game', type: :feature, js: true do
  include CodebreakerPageDSL

  before do
    visit 'localhost:9292/'
    select 'Easy', from: 'diff'
    click_button 'Play'
    wrong_code = find_out_wrong_code
    10.times { submit_code(wrong_code) }
  end

  it "redirects to '/result'" do
    expect(current_path).to eq '/result'
  end

  it 'indicates that player has lost' do
    expect(page).to have_content('Defeat!')
  end
end
