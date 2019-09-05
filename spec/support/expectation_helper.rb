module ExpectationHelper
  def expect_to_see(content)
    expect(page).to have_content content
  end

  def expect_to_see_no(content)
    expect(page).to_not have_content content
  end
end
