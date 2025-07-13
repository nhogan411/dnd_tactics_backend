require 'rails_helper'

RSpec.describe BattleServices::TurnSubmissionService, type: :service do
  let(:battle_board) { create(:battle_board) }
  let(:battle) { create(:battle, battle_board: battle_board, current_turn_index: 0) }
  let(:participant) { create(:battle_participant, battle: battle, turn_order: 0, pos_x: 5, pos_y: 5) }
  let(:target) { create(:battle_participant, battle: battle, team: 2, turn_order: 1, pos_x: 6, pos_y: 5) }

  before do
    # Make sure the participant is the current turn
    allow(battle).to receive(:current_participant).and_return(participant)
  end

  describe '#valid_submission?' do
    it 'returns true for valid submission' do
      service = described_class.new(battle, participant, { action_type: "move", target_x: 6, target_y: 6 })
      expect(service.valid_submission?).to be true
    end

    it 'returns false when not participant\'s turn' do
      other_participant = create(:battle_participant, battle: battle, turn_order: 1)
      service = described_class.new(battle, other_participant, { action_type: "move", target_x: 6, target_y: 6 })
      expect(service.valid_submission?).to be false
    end

    it 'returns false for invalid action type' do
      service = described_class.new(battle, participant, { action_type: "invalid", target_x: 6, target_y: 6 })
      expect(service.valid_submission?).to be false
    end
  end

  describe '#execute!' do
    context 'move action' do
      let(:service) { described_class.new(battle, participant, { action_type: "move", target_x: 6, target_y: 6 }) }

      it 'executes movement' do
        expect_any_instance_of(BattleServices::MovementService).to receive(:execute!)
        service.execute!
      end
    end

    context 'attack action' do
      let(:service) { described_class.new(battle, participant, { action_type: "attack", target_id: target.id }) }

      it 'executes attack' do
        expect_any_instance_of(BattleServices::CombatService).to receive(:attack).with(target)
        service.execute!
      end
    end

    context 'end_turn action' do
      let(:service) { described_class.new(battle, participant, { action_type: "end_turn" }) }

      it 'advances turn and applies status effects' do
        expect_any_instance_of(Battle::StatusManager).to receive(:tick!)
        expect_any_instance_of(BattleServices::TurnService).to receive(:next_turn!)
        service.execute!
      end
    end
  end
end
