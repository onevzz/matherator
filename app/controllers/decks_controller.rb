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
    @flashcards = Flashcard.all
  end

  # GET /decks/new
  def new
    #@deck = Deck.new
    @deck = current_user.decks.build
    @flashcards = Flashcard.all
  end

  # GET /decks/1/edit
  def edit
    @flashcards = Flashcard.all
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

  def download
    require "securerandom"
    @deck = Deck.find(params[:id])
    index = 1
    identifier = SecureRandom.uuid
    title = @deck.code
    tabletop = Array.new
    tablebop = Array.new
    card_array = @deck.content.split(', ')
    card_array.each do |card|
      card_front = card.gsub(/\(.*\)/, "")
      card_back = card.gsub(/^.*\(/, "").gsub(/\)/, "").to_i
      Flashcard.all.each do |flashcard|
        if flashcard.user == current_user && flashcard.code == card_front
          card_back.times do
            round = 0
            round_answer = 2
            table = Hash.new(0)
            question = flashcard.question + " "
            answer_str = flashcard.answer + " "
            whole_array = answer_str.scan(/\$.*?(?=[^A-Za-z0-9\.])/)
            answer_str = answer_str.gsub(/[A-Za-z].*?(?=[^A-Za-z0-9\.])/, "")
            whole_array.each do |element|
              element = element + " "
              if element.include?(".")
                round = 2
              end
              variable = element.scan(/\$.*?(?=[^0-9])/)
              min = element.scan(/(?<=min).*?(?=[^0-9\.])/)
              max = element.scan(/(?<=max).*?(?=[^0-9\.])/)
              table[variable[0]] = rand(min[0].to_f..max[0].to_f).round(round).to_s
              round = 0
            end
            table.each do |key, value|
              question = question.gsub(key, value)
              answer_str = answer_str.gsub(key, value)
            end
            answer = eval(answer_str).to_f.round(round_answer)
            if answer%1==0
              answer=answer.to_i
            end
            primary = index.to_s + ") " + question
            secondary = "Answer: " + answer_str.to_s + " = " + answer.to_s + " " + flashcard.unit
            index = index + 1
            tabletop.push(primary)
            tablebop.push(secondary)
          end
        end
      end
    end
    pdf = Prawn::Document.new(:page_size => "A4")
    pdf.font "#{Rails.root}/app/assets/fonts/NotoSerifThai/static/NotoSerifThai/NotoSerifThai-Regular.ttf", :size => 12
    pdf.text title + " (UUID: " + identifier + ")"
    pdf.text "Generated by Matherator - An ESMTE Collaboration Project (Thailand)"
    pdf.text "--------------------------------------------------------------------------------------------------------------------------------------------\n"
    tabletop.each do |problem|
      if pdf.cursor < 100
        pdf.start_new_page
      end
      pdf.text problem
      pdf.text "\n\n"
      pdf.text "--------------------------------------------------------------------------------------------------------------------------------------------\n"
    end
    pdf.start_new_page
    pdf.text title + " (UUID: " + identifier + ")" + " [ANSWER KEY]"
    pdf.text "Generated by Matherator - An ESMTE Collaboration Project (Thailand)"
    pdf.text "--------------------------------------------------------------------------------------------------------------------------------------------\n"
    tabletop.each_with_index do |problem, index|
      if pdf.cursor < 100
        pdf.start_new_page
      end
      pdf.text problem
      pdf.text tablebop[index]
      pdf.text "\n"
      pdf.text "--------------------------------------------------------------------------------------------------------------------------------------------\n"
    end
    send_data(pdf.render, filename: 'Matherator.pdf', type: 'application/pdf')
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
