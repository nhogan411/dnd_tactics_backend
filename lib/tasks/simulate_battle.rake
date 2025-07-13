namespace :battle do
  desc "Simulate a full battle loop"
  task simulate: :environment do
    battle = Battle.last
    service = BattleServices::TurnService.new(battle)

    30.times do
      puts "Turn: #{(battle.current_turn_index || 0) + 1}"
      service.simulate_attack_turn
    end

    puts "Battle ended at turn #{battle.current_turn_index}"
  end
end
