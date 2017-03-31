require 'spec_helper'

RSpec.describe "pages accessibility", type: :feature do
  it "page '/'" do
    visit '/'

    expect(page.status_code).to eq(200)
    expect(page).to have_content 'Leaderboards'
    expect(page).to have_button 'Play'
    expect(page).to have_selector '#game-description'
  end
end
