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

  it 'shows correct Victory page' do
    expect(current_path).to eq '/result'
    expect(page).to have_content('Victory!')
    expect(page).to have_content('Your score:')
    expect(page.text).to match /You actually took \d+ place in leaderboards/
    expect(page).to have_button('Submit')
    expect(page).to have_link('Skip')
  end

  describe 'when Submitting results' do
    before do
      click_button 'Submit'
    end

    it "Redirects to home and updates Leaderboards" do
      expect(current_path).to eq '/'
      expect(@leaderboards).to_not eql get_leaderboards
    end
  end

  describe 'when Skipping' do
    before do
      click_link 'Skip'
    end

    it "Redirects to Home and does not pdate Leaderboards" do
      expect(current_path).to eq '/'
      expect(@leaderboards).to eql get_leaderboards
    end
  end
end
