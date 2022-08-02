class DecksController < ApplicationController
  before_action :set_deck, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only:[:show, :edit, :update, :destroy]

  # GET /decks or /decks.json
  def index
    @decks = Deck.all
  end

  # GET /decks/1 or /decks/1.json
  def show
  end

  # GET /decks/new
  def new
    #@deck = Deck.new
    @deck = current_user.decks.build
  end

  # GET /decks/1/edit
  def edit
  end

  # POST /decks or /decks.json
  def create
    #@deck = Deck.new(deck_params)
    @deck = current_user.decks.build(deck_params)

    respond_to do |format|
      if @deck.save
        format.html { redirect_to deck_url(@deck), notice: "Deck was successfully created." }
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /decks/1 or /decks/1.json
  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html { redirect_to deck_url(@deck), notice: "Deck was successfully updated." }
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1 or /decks/1.json
  def destroy
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to decks_url, notice: "Deck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @deck = current_user.decks.find_by(:id => params[:id])
    redirect_to decks_path, notice:"Not Authorized to access this deck" if @deck.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deck_params
      params.require(:deck).permit(:code, :content, :user_id)
    end
end
