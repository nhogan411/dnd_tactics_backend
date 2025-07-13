class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [ :show, :update, :destroy ]

  # GET /characters
  def index
    @characters = current_user.characters.includes(:race, :character_class)
    render json: @characters
  end

  # GET /characters/1
  def show
    render json: @character
  end

  # POST /characters
  def create
    @character = current_user.characters.new(character_params)
    # Add default ability scores and modifiers logic here or in model callbacks
    if @character.save
      render json: @character, status: :created
    else
      render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /characters/1
  def update
    if @character.update(character_params)
      render json: @character
    else
      render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /characters/1
  def destroy
    @character.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = current_user.characters.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def character_params
      params.require(:character).permit(:name, :race_id, :character_class_id, :level, :movement_speed, ability_scores: {})
    end
end









class Api::CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [ :show, :update, :destroy ]

  def index
    @characters = current_user.characters.includes(:race, :character_class)
    render json: @characters
  end

  def show
    render json: @character
  end

  def create
    @character = current_user.characters.new(character_params)
    # Add default ability scores and modifiers logic here or in model callbacks
    if @character.save
      render json: @character, status: :created
    else
      render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @character.update(character_params)
      render json: @character
    else
      render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy
    head :no_content
  end

  private

    def set_character
      @character = current_user.characters.find(params[:id])
    end

    def character_params
      params.require(:character).permit(:name, :race_id, :character_class_id, :level, :movement_speed, ability_scores: {})
    end
end
