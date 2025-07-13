class CharacterClassesController < ApplicationController
  before_action :set_character_class, only: %i[ show update destroy ]

  # GET /character_classes
  def index
    @character_classes = CharacterClass.all

    render json: @character_classes
  end

  # GET /character_classes/1
  def show
    render json: @character_class
  end

  # POST /character_classes
  def create
    @character_class = CharacterClass.new(character_class_params)

    if @character_class.save
      render json: @character_class, status: :created, location: @character_class
    else
      render json: @character_class.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /character_classes/1
  def update
    if @character_class.update(character_class_params)
      render json: @character_class
    else
      render json: @character_class.errors, status: :unprocessable_entity
    end
  end

  # DELETE /character_classes/1
  def destroy
    @character_class.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character_class
      @character_class = CharacterClass.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def character_class_params
      params.expect(character_class: [ :name, :ability_requirements, :bonuses ])
    end
end
