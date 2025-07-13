module BattleServices
  class BoardGenerator
    SURFACES = %w[grass dirt stone mud wood sand].freeze

    def initialize(name: "Battlefield", width: 100, height: 100)
      @name = name
      @width = width
      @height = height
    end

    def run
      board = BattleBoard.create!(name: @name, width: @width, height: @height)

      puts "Generating squares..."
      squares = []
      @height.times do |y|
        @width.times do |x|
          squares << {
            battle_board_id: board.id,
            x: x,
            y: y,
            height: rand(0..3),
            brightness: rand(1..10),
            surface_type: SURFACES.sample,
            created_at: Time.now,
            updated_at: Time.now
          }
        end
      end
      BoardSquare.insert_all!(squares)

      puts "Generating starting squares..."
      add_starting_positions(board)

      board
    end

    private

      def add_starting_positions(board)
        # Team 1: bottom-left
        generate_starting_positions(board, team: 1, x_range: 0..10, y_range: 0..10)

        # Team 2: top-right
        generate_starting_positions(board, team: 2, x_range: 89..99, y_range: 89..99)
      end

      def generate_starting_positions(board, team:, x_range:, y_range:)
        coords = []
        until coords.size == 5
          x = rand(x_range)
          y = rand(y_range)
          coords << [ x, y ] unless coords.include?([ x, y ])
        end

        coords.each do |x, y|
          StartingSquare.create!(battle_board: board, x: x, y: y, team: team)
        end
      end
  end
end
