require 'rails_helper'

RSpec.describe BattleServices::TurnService do
  let(:battle_setup) { setup_basic_battle }
  let(:battle) { battle_setup[:battle] }
  let(:participant1) { battle_setup[:participant1] }
  let(:participant2) { battle_setup[:participant2] }
  let(:service) { described_class.new(battle) }

  before do
    battle.update!(status: "active", current_turn_index: 0)
  end

  describe '#current_participant' do
    it 'returns the participant with the current turn index' do
      expect(service.current_participant).to eq(participant1)
    end

    it 'returns nil if no active participant at current index' do
      participant1.update!(status: "defeated")

      expect(service.current_participant).to be_nil
    end
  end

  describe '#next_turn!' do
    it 'advances to the next participant' do
      service.next_turn!

      expect(battle.reload.current_turn_index).to eq(participant2.turn_order)
    end

    it 'wraps to first participant after last participant' do
      battle.update!(current_turn_index: participant2.turn_order)
      service.next_turn!

      expect(battle.reload.current_turn_index).to eq(participant1.turn_order)
    end

    it 'skips defeated participants' do
      participant2.update!(status: "defeated")
      service.next_turn!

      # Should wrap back to participant1 since participant2 is defeated
      expect(battle.reload.current_turn_index).to eq(participant1.turn_order)
    end

    it 'applies start of turn effects' do
      participant1.update!(cooldowns: { "rage" => 2 })

      service.next_turn!

      # Cooldowns should be reduced by 1
      expect(participant1.reload.cooldowns["rage"]).to eq(1)
    end

    it 'logs turn start' do
      expect(BattleServices::Logger).to receive(:log_turn_start).with(battle, participant2)

      service.next_turn!
    end

    it 'ends battle if no active participants' do
      participant1.update!(status: "defeated")
      participant2.update!(status: "defeated")

      service.next_turn!

      expect(battle.reload.status).to eq("completed")
      expect(battle.winner).to be_nil
    end
  end

  describe '#reset_turn_order!' do
    it 'rerolls initiative for all active participants' do
      expect(BattleServices::DiceRoller).to receive(:d20).twice.and_return({
        total: 15, rolls: [15], modifier: 0, formula: "1d20"
      })

      service.reset_turn_order!

      expect(participant1.reload.initiative_roll).to eq(15)
      expect(participant2.reload.initiative_roll).to eq(15)
    end

    it 'logs initiative reroll' do
      expect(BattleServices::Logger).to receive(:log_initiative_reroll).with(battle)

      service.reset_turn_order!
    end    # TODO: Re-enable when turn_count column is added
    xit 'increments turn count' do
      initial_turn_count = battle.turn_count

      service.reset_turn_order!

      expect(battle.reload.turn_count).to eq(initial_turn_count + 1)
    end
  end

  describe '#simulate_attack_turn' do
    it 'executes an attack against an enemy' do
      expect_any_instance_of(BattleServices::AttackService).to receive(:execute!)

      service.simulate_attack_turn
    end

    it 'advances turn after attack' do
      allow_any_instance_of(BattleServices::AttackService).to receive(:execute!)

      service.simulate_attack_turn

      expect(battle.reload.current_turn_index).to eq(participant2.turn_order)
    end

    it 'does nothing if no valid targets' do
      participant2.update!(status: "defeated")

      expect_any_instance_of(BattleServices::AttackService).not_to receive(:execute!)

      service.simulate_attack_turn
    end
  end
end
