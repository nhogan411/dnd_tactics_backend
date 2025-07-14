require 'rails_helper'

RSpec.describe BattleServices::DiceRoller do
  describe '.roll' do
    it 'rolls the correct number of dice with correct sides' do
      result = described_class.roll(6, 2, 3)

      expect(result[:rolls].length).to eq(2)
      expect(result[:rolls]).to all(be_between(1, 6))
      expect(result[:total]).to eq(result[:rolls].sum + 3)
      expect(result[:modifier]).to eq(3)
      expect(result[:formula]).to eq("2d6+3")
    end

    it 'handles zero modifier correctly' do
      result = described_class.roll(20, 1, 0)

      expect(result[:formula]).to eq("1d20")
      expect(result[:modifier]).to eq(0)
    end

    it 'handles negative modifier correctly' do
      result = described_class.roll(8, 1, -2)

      expect(result[:formula]).to eq("1d8-2")
      expect(result[:total]).to eq(result[:rolls][0] - 2)
    end
  end

  describe '.d20' do
    it 'rolls a d20 with modifier' do
      result = described_class.d20(1, 5)

      expect(result[:rolls].length).to eq(1)
      expect(result[:rolls][0]).to be_between(1, 20)
      expect(result[:total]).to eq(result[:rolls][0] + 5)
    end
  end

  describe '.d20_advantage' do
    it 'takes the higher of two d20 rolls' do
      # Mock the random number generator to test advantage logic
      allow_any_instance_of(Object).to receive(:rand).and_return(10, 15)

      result = described_class.d20_advantage(2)

      expect(result[:rolls]).to contain_exactly(10, 15)
      expect(result[:best_roll]).to eq(15)
      expect(result[:total]).to eq(17) # 15 + 2
      expect(result[:advantage]).to be true
    end
  end

  describe '.d20_disadvantage' do
    it 'takes the lower of two d20 rolls' do
      allow_any_instance_of(Object).to receive(:rand).and_return(10, 15)

      result = described_class.d20_disadvantage(2)

      expect(result[:rolls]).to contain_exactly(10, 15)
      expect(result[:worst_roll]).to eq(10)
      expect(result[:total]).to eq(12) # 10 + 2
      expect(result[:disadvantage]).to be true
    end
  end

  describe '.parse_and_roll' do
    it 'parses and rolls "2d6+3"' do
      result = described_class.parse_and_roll("2d6+3")

      expect(result[:rolls].length).to eq(2)
      expect(result[:rolls]).to all(be_between(1, 6))
      expect(result[:modifier]).to eq(3)
    end

    it 'parses and rolls "d20"' do
      result = described_class.parse_and_roll("d20")

      expect(result[:rolls].length).to eq(1)
      expect(result[:rolls][0]).to be_between(1, 20)
      expect(result[:modifier]).to eq(0)
    end

    it 'handles invalid notation' do
      result = described_class.parse_and_roll("invalid")

      expect(result[:error]).to eq("Invalid dice notation")
    end
  end
end
