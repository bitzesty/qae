require "rails_helper"

describe UserSearch do
  before do
    [
      %w[Harmony Pelham account_admin],
      %w[Noella Adan account_admin],
      %w[Margot Tito account_admin],
      %w[Curt Knickerbocker regular],
      %w[Lea Reimer account_admin],
      %w[Lea Tencher regular],
      %w[Catrice Berk account_admin],
    ].each do |(first_name, last_name, role)|
      create(:user, first_name:, last_name:, role:)
    end
  end

  it "sorts user by full name" do
    results = described_class.new(User.all).search(sort: "full_name").results

    sorted_names = results.map { |user| "#{user.first_name} #{user.last_name}" }
    expected =
      [
        "Catrice Berk",
        "Curt Knickerbocker",
        "Harmony Pelham",
        "Lea Reimer",
        "Lea Tencher",
        "Margot Tito",
        "Noella Adan",
      ]
    expect(sorted_names).to eq(expected)
  end

  it "filters by role" do
    results = described_class.new(User.all).search(sort: "full_name", search_filter: { role: "regular" }).results

    sorted_names = results.map { |user| "#{user.first_name} #{user.last_name}" }
    expected =
      [
        "Curt Knickerbocker",
        "Lea Tencher",
      ]
    expect(sorted_names).to eq(expected)
  end
end
