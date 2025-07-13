class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [:show, :update, :destroy]

  # GET /characters
  def index
    @characters = current_user.characters.includes(:race, :subrace, :character_class, :subclass)
    render json: @characters
  end

  # GET /characters/1
  def show
    render json: @character
  end

  # POST /characters
  def create
    @character = current_user.characters.new(character_params)
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

  def set_character
    @character = current_user.characters.find(params[:id])
  end

  def character_params
    params.require(:character).permit(:name, :race_id, :subrace_id, :character_class_id, :subclass_id, :level, :movement_speed, :max_hp, :visibility_range)
  end
end
