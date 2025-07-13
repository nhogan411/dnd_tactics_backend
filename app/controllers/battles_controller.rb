class BattlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_battle, only: [:show, :update, :destroy]

  # GET /battles
  def index
    @battles = Battle.includes(:player_1, :player_2, :winner).all
    render json: @battles
  end

  # GET /battles/1
  def show
    render json: @battle
  end

  # POST /battles
  def create
    @battle = Battle.new(battle_params)
    if @battle.save
      render json: @battle, status: :created
    else
      render json: { errors: @battle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /battles/1
  def update
    if @battle.update(battle_params)
      render json: @battle
    else
      render json: { errors: @battle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /battles/1
  def destroy
    @battle.destroy
    head :no_content
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
  end

  def battle_params
    params.require(:battle).permit(:user_1_id, :user_2_id, :winner_id, :status, :battle_board_id)
  end
end
