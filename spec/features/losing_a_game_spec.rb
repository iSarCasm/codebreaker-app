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

  it "shows a loss page" do
    expect(current_path).to eq '/result'
    expect(page).to have_content('Defeat!')
    expect(page).to have_link('Go Home..')
  end
end
