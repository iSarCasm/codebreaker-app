require 'spec_helper'

RSpec.describe "pages accessibility", type: :feature do
  describe "'/'" do
    before do
      visit '/'
    end

    it "page is accessible" do
      expect(page.status_code).to eq(200)
    end

    it 'contains leaderboards' do
      expect(page).to have_content 'Leaderboards'
    end

    it 'contains Play button' do
      expect(page).to have_button 'Play'
    end

    it 'contains game description' do
      expect(page).to have_selector '#game-description'
    end
  end
end
