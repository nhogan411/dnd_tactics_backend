class Battle < ApplicationRecord
  belongs_to :player_1, class_name: "User", foreign_key: "user_1_id"
  belongs_to :player_2, class_name: "User", foreign_key: "user_2_id"
  belongs_to :winner, class_name: "User", foreign_key: "winner_id", optional: true
  belongs_to :battle_board

  has_many :battle_participants, dependent: :destroy
  has_many :battle_logs, dependent: :destroy

  # Add aliases for backward compatibility
  alias_method :user_1, :player_1
  alias_method :user_2, :player_2
  alias_method :user_1=, :player_1=
  alias_method :user_2=, :player_2=

  # Helper methods for battle management
  def active_participants
    battle_participants.where(status: "active")
  end

  def team_1_participants
    battle_participants.where(team: 1)
  end

  def team_2_participants
    battle_participants.where(team: 2)
  end

  def current_participant
    participants_by_turn = battle_participants.order(:turn_order)
    current_index = (current_turn_index || 0) % participants_by_turn.count
    participants_by_turn[current_index]
  end

  # Status checks
  def active?
    status == 'active'
  end

  def finished?
    status == 'finished'
  end

  def waiting?
    status == 'waiting'
  end

  def has_winner?
    winner_id.present?
  end

  # Turn management
  def next_turn!
    self.current_turn_index = (current_turn_index + 1) % battle_participants.count
    self.turn_count += 1
    save
  end

  def current_turn_participant
    return nil unless battle_participants.any?
    participants_by_turn = battle_participants.order(:turn_order)
    current_index = (current_turn_index || 0) % participants_by_turn.count
    participants_by_turn[current_index]
  end

  def is_participant_turn?(character)
    current_turn_participant&.character == character
  end

  # Battle state
  def alive_participants
    battle_participants.joins(:character).where('characters.current_hp > 0')
  end

  def dead_participants
    battle_participants.joins(:character).where('characters.current_hp <= 0')
  end

  def team_alive?(team_number)
    battle_participants.joins(:character)
                     .where(team: team_number)
                     .where('characters.current_hp > 0')
                     .exists?
  end

  def winning_team
    return nil unless finished?
    return 1 if team_alive?(1) && !team_alive?(2)
    return 2 if team_alive?(2) && !team_alive?(1)
    nil
  end

  def check_victory_conditions
    return false if finished?

    team_1_alive = team_alive?(1)
    team_2_alive = team_alive?(2)

    if !team_1_alive && !team_2_alive
      self.status = 'finished'
      # Draw - no winner
    elsif !team_1_alive
      self.status = 'finished'
      self.winner = player_2
    elsif !team_2_alive
      self.status = 'finished'
      self.winner = player_1
    end

    save if changed?
    finished?
  end

  # Battle statistics
  def total_damage_dealt
    battle_logs.where(action_type: 'damage').sum(:damage_amount)
  end

  def total_healing_done
    battle_logs.where(action_type: 'heal').sum(:healing_amount)
  end

  def participant_damage(character)
    battle_logs.where(actor: character, action_type: 'damage').sum(:damage_amount)
  end

  def participant_healing(character)
    battle_logs.where(actor: character, action_type: 'heal').sum(:healing_amount)
  end

  # Audit and summary methods
  def audit
    {
      id: id,
      status: status,
      turn_count: turn_count,
      current_turn: current_turn_index,
      current_participant: current_turn_participant&.character&.name,
      participants: battle_participants.count,
      team_1_alive: team_alive?(1),
      team_2_alive: team_alive?(2),
      winner: winner&.name,
      total_damage: total_damage_dealt,
      total_healing: total_healing_done,
      battle_board: battle_board&.name
    }
  end

  def summary_hash
    {
      id: id,
      status: status,
      turn_count: turn_count,
      participants: battle_participants.count,
      winner: winner&.name,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
