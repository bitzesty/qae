require 'rails_helper'
include Warden::Test::Helpers

describe 'Admin comments management', %q{
As a Admin
I want to be able to view, create and destroy the comments per application.
} do

  let!(:admin){ create(:admin)}
  let!(:form_answer){ create(:form_answer) }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  it 'adds the comment' do
    populate_comment_form

    expect{ click_button 'Add Comment' }.to change{Comment.count}.by(1)
  end

  it 'deletes the comment' do
    populate_comment_form
    click_button 'Add Comment'

    expect{ click_button 'delete' }.to change{Comment.count}.by(-1)
  end

  it 'displays the comments' do
    populate_comment_form
    click_button 'Add Comment'
    visit admin_form_answer_path(form_answer)

    expect(page).to have_css('.comment-content', text: 'body')
  end

  private

  def populate_comment_form
    click_link 'Enter a Comment'
    fill_in('comment_body', with: 'body')
  end
end
