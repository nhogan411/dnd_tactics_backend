require 'rails_helper'

RSpec.describe Api::V1::ParticipantsController, type: :controller do
  let(:battle_board) { create(:battle_board) }
  let(:battle) { create(:battle, battle_board: battle_board) }
  let(:participant) { create(:battle_participant, battle: battle) }
  let(:target) { create(:battle_participant, battle: battle, team: 2, pos_x: 6, pos_y: 5) }

  before do
    allow(battle).to receive(:current_participant).and_return(participant)
  end

  describe 'POST #move' do
    it 'successfully moves participant' do
      allow_any_instance_of(BattleServices::TurnSubmissionService).to receive(:execute!).and_return({ success: true })

      post :move, params: { battle_id: battle.id, id: participant.id, target_x: 6, target_y: 6 }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['success']).to be true
    end

    it 'returns error for invalid move' do
      allow_any_instance_of(BattleServices::TurnSubmissionService).to receive(:execute!).and_raise("Invalid move")

      post :move, params: { battle_id: battle.id, id: participant.id, target_x: 15, target_y: 15 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq("Invalid move")
    end
  end

  describe 'POST #attack' do
    it 'successfully attacks target' do
      allow_any_instance_of(BattleServices::TurnSubmissionService).to receive(:execute!).and_return({ success: true, damage: 8 })

      post :attack, params: { battle_id: battle.id, id: participant.id, target_id: target.id }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['success']).to be true
    end
  end

  describe 'POST #end_turn' do
    it 'successfully ends turn' do
      allow_any_instance_of(BattleServices::TurnSubmissionService).to receive(:execute!).and_return({ success: true, message: "Turn ended" })

      post :end_turn, params: { battle_id: battle.id, id: participant.id }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['success']).to be true
    end
  end
end
