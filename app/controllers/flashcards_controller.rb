class FlashcardsController < ApplicationController
  before_action :set_flashcard, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only:[:show, :edit, :update, :destroy]

  # GET /flashcards or /flashcards.json
  def index
    @flashcards = Flashcard.all
  end

  # GET /flashcards/1 or /flashcards/1.json
  def show
  end

  # GET /flashcards/new
  def new
    #@flashcard = Flashcard.new
    @flashcard = current_user.flashcards.build
  end

  # GET /flashcards/1/edit
  def edit
  end

  # POST /flashcards or /flashcards.json
  def create
    #@flashcard = Flashcard.new(flashcard_params)
    @flashcard = current_user.flashcards.build(flashcard_params)

    respond_to do |format|
      if @flashcard.save
        format.html { redirect_to flashcard_url(@flashcard), notice: "Flashcard was successfully created." }
        format.json { render :show, status: :created, location: @flashcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flashcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flashcards/1 or /flashcards/1.json
  def update
    respond_to do |format|
      if @flashcard.update(flashcard_params)
        format.html { redirect_to flashcard_url(@flashcard), notice: "Flashcard was successfully updated." }
        format.json { render :show, status: :ok, location: @flashcard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flashcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flashcards/1 or /flashcards/1.json
  def destroy
    @flashcard.destroy

    respond_to do |format|
      format.html { redirect_to flashcards_url, notice: "Flashcard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @flashcard = current_user.flashcards.find_by(:id => params[:id])
    redirect_to flashcards_path, notice:"Not Authorized to access this flashcard" if @flashcard.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flashcard
      @flashcard = Flashcard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flashcard_params
      params.require(:flashcard).permit(:code, :question, :answer, :unit, :user_id)
    end
end
