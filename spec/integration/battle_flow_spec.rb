require 'rails_helper'

RSpec.describe 'Battle Integration', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:battle_board) { create(:battle_board, width: 10, height: 10) }
  let(:battle) { create(:battle, player_1: user1, player_2: user2, battle_board: battle_board, status: "active") }

  let(:char1) { create(:character, user: user1, movement_speed: 6) }
  let(:char2) { create(:character, user: user2, movement_speed: 6) }

  let!(:participant1) { create(:battle_participant, battle: battle, character: char1, user: user1, team: 1, pos_x: 2, pos_y: 2, turn_order: 0) }
  let!(:participant2) { create(:battle_participant, battle: battle, character: char2, user: user2, team: 2, pos_x: 7, pos_y: 7, turn_order: 1) }

  before do
    battle.update!(current_turn_index: 0)
  end

  describe 'Complete battle turn sequence' do
    it 'allows participant to move, attack, and end turn' do
      # 1. Move participant closer to target
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/move",
           params: { target_x: 5, target_y: 5 }

      puts "Response status: #{response.status}"
      puts "Response body: #{response.body}" if response.status != 200
      expect(response).to have_http_status(:success)
      participant1.reload
      expect(participant1.pos_x).to eq(5)
      expect(participant1.pos_y).to eq(5)

      # 2. Move again to get within attack range
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/move",
           params: { target_x: 6, target_y: 7 }

      puts "Second move - Response status: #{response.status}"
      puts "Second move - Response body: #{response.body}" if response.status != 200
      expect(response).to have_http_status(:success)
      participant1.reload
      expect(participant1.pos_x).to eq(6)
      expect(participant1.pos_y).to eq(7)

      # 3. Attack the target
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/attack",
           params: { target_id: participant2.id }

      expect(response).to have_http_status(:success)

      # Check that damage was dealt
      participant2.reload
      expect(participant2.current_hp).to be < char2.max_hp

      # 4. End turn
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/end_turn"

      expect(response).to have_http_status(:success)
      result = JSON.parse(response.body)
      expect(result['success']).to be true

      # Check that turn advanced
      battle.reload
      expect(battle.current_turn_index).to eq(1)
      expect(battle.current_participant).to eq(participant2)
    end

    it 'prevents invalid moves' do
      # Try to move out of bounds
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/move",
           params: { target_x: 15, target_y: 15 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to be_present
    end

    it 'prevents attacking when out of range' do
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/attack",
           params: { target_id: participant2.id }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to be_present
    end

    it 'logs all battle actions' do
      initial_log_count = BattleLog.count

      # Perform a move
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/move",
           params: { target_x: 3, target_y: 3 }

      expect(BattleLog.count).to eq(initial_log_count + 1)

      latest_log = BattleLog.last
      expect(latest_log.action_type).to eq("movement")
      expect(latest_log.actor).to eq(char1)
    end
  end

  describe 'Battle end conditions' do
    it 'ends battle when all participants of one team are defeated' do
      # Reduce participant2's HP to 1
      participant2.update!(current_hp: 1)

      # Move close enough to attack
      participant1.update!(pos_x: 6, pos_y: 7)

      # Attack to defeat the participant
      post "/api/v1/battles/#{battle.id}/participants/#{participant1.id}/attack",
           params: { target_id: participant2.id }

      expect(response).to have_http_status(:success)

      # Check that battle ended
      battle.reload
      expect(battle.status).to eq("completed")
      expect(battle.winner).to eq(user1)
    end
  end
end
