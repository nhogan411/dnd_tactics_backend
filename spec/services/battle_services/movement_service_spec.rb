require 'rails_helper'

RSpec.describe BattleServices::MovementService, type: :service do
  let(:battle_board) { create(:battle_board, width: 10, height: 10) }
  let(:battle) { create(:battle, battle_board: battle_board) }
  let(:participant) { create(:battle_participant, battle: battle, pos_x: 5, pos_y: 5) }

  describe '#valid_move?' do
    context 'with valid move' do
      let(:service) { described_class.new(participant, 6, 6) }

      it 'returns true for valid adjacent move' do
        expect(service.valid_move?).to be true
      end
    end

    context 'with invalid moves' do
      it 'returns false for out of bounds move' do
        service = described_class.new(participant, 15, 15)
        expect(service.valid_move?).to be false
      end

      it 'returns false for move exceeding movement speed' do
        # Create character with low movement speed
        low_speed_char = create(:character, movement_speed: 5)
        low_speed_participant = create(:battle_participant, battle: battle, character: low_speed_char, pos_x: 5, pos_y: 5)
        service = described_class.new(low_speed_participant, 1, 1) # 8 squares away, movement_speed is 5
        expect(service.valid_move?).to be false
      end

      it 'returns false for occupied square' do
        create(:battle_participant, battle: battle, pos_x: 6, pos_y: 6)
        service = described_class.new(participant, 6, 6)
        expect(service.valid_move?).to be false
      end
    end
  end

  describe '#execute!' do
    let(:service) { described_class.new(participant, 6, 6) }

    it 'updates participant position' do
      expect { service.execute! }.to change { participant.reload.pos_x }.from(5).to(6)
        .and change { participant.reload.pos_y }.from(5).to(6)
    end

    it 'creates a battle log entry' do
      expect { service.execute! }.to change { BattleLog.count }.by(1)
    end

    it 'returns success result' do
      result = service.execute!
      expect(result[:success]).to be true
      expect(result[:from]).to eq({ x: 5, y: 5 })
      expect(result[:to]).to eq({ x: 6, y: 6 })
    end
  end
end
