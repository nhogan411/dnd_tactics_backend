require 'rails_helper'

RSpec.describe Battle, type: :model do
  describe 'associations' do
    it { should belong_to(:player_1).class_name('User').with_foreign_key('user_1_id') }
    it { should belong_to(:player_2).class_name('User').with_foreign_key('user_2_id') }
    it { should belong_to(:winner).class_name('User').with_foreign_key('winner_id').optional }
    it { should belong_to(:battle_board) }
    it { should have_many(:battle_participants).dependent(:destroy) }
    it { should have_many(:battle_logs).dependent(:destroy) }
  end

  describe 'helper methods' do
    let(:battle_board) { create(:battle_board) }
    let(:battle) { create(:battle, battle_board: battle_board) }
    let!(:team1_participant) { create(:battle_participant, battle: battle, team: 1, status: "active") }
    let!(:team2_participant) { create(:battle_participant, battle: battle, team: 2, status: "active") }
    let!(:inactive_participant) { create(:battle_participant, battle: battle, team: 1, status: "knocked_out") }

    describe '#active_participants' do
      it 'returns only active participants' do
        expect(battle.active_participants).to contain_exactly(team1_participant, team2_participant)
      end
    end

    describe '#team_1_participants' do
      it 'returns team 1 participants' do
        expect(battle.team_1_participants).to contain_exactly(team1_participant, inactive_participant)
      end
    end

    describe '#team_2_participants' do
      it 'returns team 2 participants' do
        expect(battle.team_2_participants).to contain_exactly(team2_participant)
      end
    end

    describe '#current_participant' do
      before do
        team1_participant.update!(turn_order: 0)
        team2_participant.update!(turn_order: 1)
        battle.update!(current_turn_index: 0)
      end

      it 'returns the participant whose turn it is' do
        expect(battle.current_participant).to eq(team1_participant)
      end
    end
  end
end
