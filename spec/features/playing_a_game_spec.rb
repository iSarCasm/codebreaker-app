require 'spec_helper'

RSpec.describe 'playing a game', type: :feature, js: true do
  include CodebreakerPageTags

  before do
    visit 'localhost:9292/'
    select 'Easy', from: 'diff'
    click_button 'Play'
  end

  describe 'submitting a guess' do
   context 'when guess is empty' do
     it "doesn't count as an attempt" do
       expect {click_button 'Submit' }.to_not change{ page_play_attempts_left }
     end
   end

   context 'when guess is using wrong chars' do
     it "doesn't count as an attempt" do
       expect{ click_button 'Submit' }.to_not change{ page_play_attempts_left }
     end
   end

   context "when guess is using correct chars and length" do
     before do
       fill_in 'code', with: '444'
     end

     it "uses an attempt" do
       expect{ click_button 'Submit' }.to change{ page_play_attempts_left }.by(-1)
     end
   end
  end

  describe 'requesting a hint' do
    context 'when some hints available' do
      it 'returns a hint response and uses 1 hint' do
        expect{ click_link 'Hint!' }.to change{ page_play_hints_left }.by(-1)
      end
    end

    context 'when no hints available' do
      before do
        3.times { click_link 'Hint!' }
      end

      it "doesn't use a hint" do
        expect{ click_link 'Hint!' }.to_not change{ page_play_hints_left }
      end
    end
  end
end
