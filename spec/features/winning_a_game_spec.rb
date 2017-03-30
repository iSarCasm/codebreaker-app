require 'spec_helper'

RSpec.describe 'winning a game', type: :feature, js: true do
  include CodebreakerPageDSL

  before do
    visit 'localhost:9292/'
    @leaderboards = get_leaderboards
    select 'Easy', from: 'diff'
    click_button 'Play'
    submit_code find_out_correct_code
  end

  it "redirects to '/result'" do
    expect(current_path).to eq '/result'
  end

  it 'indicates that player has won' do
    expect(page).to have_content('Victory!')
  end

  it 'shows player score' do
    expect(page).to have_content('Your score:')
  end

  it 'shows leaderboard place' do
    expect(page.text).to match /You actually took \d+ place in leaderboards/
  end

  it 'shows Submit button' do
    expect(page).to have_button('Submit')
  end

  it 'shows Skip button' do
    expect(page).to have_link('Skip')
  end

  describe 'when Submitting results' do
    before do
      click_button 'Submit'
    end

    it "redirects to '/'" do
      expect(current_path).to eq '/'
    end

    it 'updates leaderboard' do
      expect(@leaderboards).to_not eql get_leaderboards
    end
  end

  describe 'when Skipping' do
    before do
      click_link 'Skip'
    end

    it "redirects to '/'" do
      expect(current_path).to eq '/'
    end

    it "doesn't update leaderboard" do
      expect(@leaderboards).to eql get_leaderboards
    end
  end
end
