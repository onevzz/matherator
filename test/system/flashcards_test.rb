require "application_system_test_case"

class FlashcardsTest < ApplicationSystemTestCase
  setup do
    @flashcard = flashcards(:one)
  end

  test "visiting the index" do
    visit flashcards_url
    assert_selector "h1", text: "Flashcards"
  end

  test "should create flashcard" do
    visit flashcards_url
    click_on "New flashcard"

    fill_in "Answer", with: @flashcard.answer
    fill_in "Code", with: @flashcard.code
    fill_in "Question", with: @flashcard.question
    fill_in "Unit", with: @flashcard.unit
    click_on "Create Flashcard"

    assert_text "Flashcard was successfully created"
    click_on "Back"
  end

  test "should update Flashcard" do
    visit flashcard_url(@flashcard)
    click_on "Edit this flashcard", match: :first

    fill_in "Answer", with: @flashcard.answer
    fill_in "Code", with: @flashcard.code
    fill_in "Question", with: @flashcard.question
    fill_in "Unit", with: @flashcard.unit
    click_on "Update Flashcard"

    assert_text "Flashcard was successfully updated"
    click_on "Back"
  end

  test "should destroy Flashcard" do
    visit flashcard_url(@flashcard)
    click_on "Destroy this flashcard", match: :first

    assert_text "Flashcard was successfully destroyed"
  end
end
