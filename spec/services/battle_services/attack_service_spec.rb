require 'rails_helper'

RSpec.describe BattleServices::AttackService do
  let(:battle_setup) { setup_basic_battle }
  let(:battle) { battle_setup[:battle] }
  let(:attacker) { battle_setup[:participant1] }
  let(:target) { battle_setup[:participant2] }

  before do
    # Position participants adjacent for melee attacks
    attacker.update!(pos_x: 5, pos_y: 5)
    target.update!(pos_x: 5, pos_y: 6)  # Adjacent
  end

  describe '#execute!' do
    let(:service) { described_class.new(attacker, target) }

    it 'successfully executes an attack against a valid target' do
      result = service.execute!

      expect(result[:success]).to be true
      expect(result).to have_key(:hit)
      expect(result).to have_key(:attack_roll)
      expect(result).to have_key(:target_ac)
      expect(result).to have_key(:damage)
    end

    it 'applies damage when attack hits' do
      # Mock dice rolls to ensure hit
      allow(BattleServices::DiceRoller).to receive(:d20).and_return({
        total: 20, rolls: [20], modifier: 0, formula: "1d20"
      })
      allow(BattleServices::DiceRoller).to receive(:roll).and_return({
        total: 8, rolls: [8], modifier: 0, formula: "1d8"
      })

      initial_hp = target.current_hp
      result = service.execute!

      expect(result[:hit]).to be true
      expect(target.reload.current_hp).to be < initial_hp
    end

    it 'does not apply damage when attack misses' do
      # Mock dice rolls to ensure miss
      allow(BattleServices::DiceRoller).to receive(:d20).and_return({
        total: 1, rolls: [1], modifier: 0, formula: "1d20"
      })

      initial_hp = target.current_hp
      result = service.execute!

      expect(result[:hit]).to be false
      expect(target.reload.current_hp).to eq(initial_hp)
    end

    it 'defeats target when HP reaches 0' do
      target.update!(current_hp: 1)

      # Mock dice to ensure hit and damage
      allow(BattleServices::DiceRoller).to receive(:d20).and_return({
        total: 20, rolls: [20], modifier: 0, formula: "1d20"
      })
      allow(BattleServices::DiceRoller).to receive(:roll).and_return({
        total: 5, rolls: [5], modifier: 0, formula: "1d4"
      })

      service.execute!

      expect(target.reload.status).to eq("defeated")
    end

    it 'raises error for invalid target (same team)' do
      same_team_target = battle_setup[:participant1]
      invalid_service = described_class.new(attacker, same_team_target)

      expect { invalid_service.execute! }.to raise_error("Invalid attack target")
    end

    it 'raises error for out of range target' do
      target.update!(pos_x: 10, pos_y: 10)  # Out of range

      expect { service.execute! }.to raise_error("Target out of range")
    end

    it 'logs the attack result' do
      expect(BattleServices::Logger).to receive(:log_attack).with(attacker, target, anything)

      service.execute!
    end
  end

  describe '#can_attack?' do
    let(:service) { described_class.new(attacker, target) }

    it 'returns true for valid target in range' do
      expect(service.can_attack?).to be true
    end

    it 'returns false for out of range target' do
      target.update!(pos_x: 10, pos_y: 10)

      expect(service.can_attack?).to be false
    end

    it 'returns false for same team target' do
      same_team_target = create(:battle_participant,
        battle: battle,
        team: attacker.team,
        character: create(:character, user: battle_setup[:user1])
      )
      invalid_service = described_class.new(attacker, same_team_target)

      expect(invalid_service.can_attack?).to be false
    end

    it 'returns false for defeated target' do
      target.update!(status: "defeated")

      expect(service.can_attack?).to be false
    end
  end

  describe 'weapon handling' do
    let(:weapon) { create(:item, item_type: "weapon", bonuses: { "damage_dice" => "1d8+2", "attack" => 1 }) }
    let(:service) { described_class.new(attacker, target, weapon) }

    before do
      create(:character_item, character: attacker.character, item: weapon, equipped: true)
    end

    it 'uses weapon damage dice' do
      allow(BattleServices::DiceRoller).to receive(:d20).and_return({
        total: 20, rolls: [20], modifier: 0, formula: "1d20"
      })
      allow(BattleServices::DiceRoller).to receive(:parse_and_roll).with("1d8+2").and_return({
        total: 10, rolls: [8], modifier: 2, formula: "1d8+2"
      })

      result = service.execute!

      expect(BattleServices::DiceRoller).to have_received(:parse_and_roll).with("1d8+2")
    end
  end
end
