class SubracesController < ApplicationController
  before_action :set_subrace, only: %i[ show update destroy ]

  # GET /subraces
  def index
    @subraces = Subrace.all

    render json: @subraces
  end

  # GET /subraces/1
  def show
    render json: @subrace
  end

  # POST /subraces
  def create
    @subrace = Subrace.new(subrace_params)

    if @subrace.save
      render json: @subrace, status: :created, location: @subrace
    else
      render json: @subrace.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subraces/1
  def update
    if @subrace.update(subrace_params)
      render json: @subrace
    else
      render json: @subrace.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subraces/1
  def destroy
    @subrace.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subrace
      @subrace = Subrace.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subrace_params
      params.expect(subrace: [ :name, :race_id, :ability_modifiers ])
    end
end
