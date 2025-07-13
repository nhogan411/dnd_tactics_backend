require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:characters).dependent(:destroy) }
    it { should have_many(:battle_participants).dependent(:destroy) }
    it { should have_many(:battle_participant_selections).dependent(:destroy) }
    it { should have_many(:battles_as_player_1).class_name('Battle').with_foreign_key('user_1_id').dependent(:destroy) }
    it { should have_many(:battles_as_player_2).class_name('Battle').with_foreign_key('user_2_id').dependent(:destroy) }
    it { should have_many(:won_battles).class_name('Battle').with_foreign_key('winner_id').dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe '#battles' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:battle_board) { create(:battle_board) }
    let!(:battle_as_player_1) { create(:battle, player_1: user, player_2: other_user, battle_board: battle_board) }
    let!(:battle_as_player_2) { create(:battle, player_1: other_user, player_2: user, battle_board: battle_board) }
    let!(:unrelated_battle) { create(:battle, player_1: other_user, player_2: other_user, battle_board: battle_board) }

    it 'returns all battles where user is a participant' do
      expect(user.battles).to contain_exactly(battle_as_player_1, battle_as_player_2)
    end
  end
end
