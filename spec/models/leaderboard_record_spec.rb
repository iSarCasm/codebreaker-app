require 'spec_helper'

RSpec.describe LeaderboardRecord do
  describe '#place' do
    context 'when no records yet' do
      before do
        allow_any_instance_of(LeaderboardRecord).to receive(:all).and_return([])
      end

      it 'returns 1' do
        new_record = LeaderboardRecord.new(score: 100)
        expect(new_record.place).to eq 1
      end
    end

    context 'when one record is there' do
      before do
        allow_any_instance_of(LeaderboardRecord).to receive(:all).and_return([
          LeaderboardRecord.new(score: 10)
        ])
      end

      it 'returns 1 when higher score' do
        new_record = LeaderboardRecord.new(score: 20)
        expect(new_record.place).to eq 1
      end

      it 'returns 2 when lower score' do
        new_record = LeaderboardRecord.new(score: 5)
        expect(new_record.place).to eq 2
      end
    end

    context 'when two records are there' do
      before do
        allow_any_instance_of(LeaderboardRecord).to receive(:all).and_return([
          LeaderboardRecord.new(score: 30),
          LeaderboardRecord.new(score: 10)
        ])
      end

      it 'returns 1 when highest score' do
        new_record = LeaderboardRecord.new(score: 40)
        expect(new_record.place).to eq 1
      end

      it 'returns 2 when middle score' do
        new_record = LeaderboardRecord.new(score: 20)
        expect(new_record.place).to eq 2
      end

      it 'returns 3 when lowest score' do
        new_record = LeaderboardRecord.new(score: 5)
        expect(new_record.place).to eq 3
      end
    end

    context 'when one records with the same score' do
      before do
        @records = [LeaderboardRecord.new(score: 10), LeaderboardRecord.new(score: 10)]
        allow_any_instance_of(LeaderboardRecord).to receive(:all).and_return(@records)
      end

      it 'records have different places' do
        expect(@records.first.place).to_not eq @records.last.place
      end

      it 'new record with highest score has 3rd place' do
        new_record = LeaderboardRecord.new(score: 20)
        expect(new_record.place).to eq 1
      end

      it 'new record with lowest score has 1st record' do
        new_record = LeaderboardRecord.new(score: 5)
        expect(new_record.place).to eq 3
      end
    end
  end
end
