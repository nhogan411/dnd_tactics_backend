class SubclassesController < ApplicationController
  before_action :set_subclass, only: %i[ show update destroy ]

  # GET /subclasses
  def index
    @subclasses = Subclass.all

    render json: @subclasses
  end

  # GET /subclasses/1
  def show
    render json: @subclass
  end

  # POST /subclasses
  def create
    @subclass = Subclass.new(subclass_params)

    if @subclass.save
      render json: @subclass, status: :created, location: @subclass
    else
      render json: @subclass.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subclasses/1
  def update
    if @subclass.update(subclass_params)
      render json: @subclass
    else
      render json: @subclass.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subclasses/1
  def destroy
    @subclass.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subclass
      @subclass = Subclass.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subclass_params
      params.expect(subclass: [ :name, :character_class_id, :bonuses ])
    end
end
