class AbilitiesController < ApplicationController
  before_action :set_ability, only: [:show, :update, :destroy]

  # GET /abilities
  def index
    @abilities = Ability.all
    render json: @abilities
  end

  # GET /abilities/1
  def show
    render json: @ability
  end

  # POST /abilities
  def create
    @ability = Ability.new(ability_params)
    if @ability.save
      render json: @ability, status: :created
    else
      render json: { errors: @ability.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /abilities/1
  def update
    if @ability.update(ability_params)
      render json: @ability
    else
      render json: { errors: @ability.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /abilities/1
  def destroy
    @ability.destroy
    head :no_content
  end

  private

  def set_ability
    @ability = Ability.find(params[:id])
  end

  def ability_params
    params.require(:ability).permit(:name, :description, :class_name, :level_required, :action_type, :cooldown_turns)
  end
end
