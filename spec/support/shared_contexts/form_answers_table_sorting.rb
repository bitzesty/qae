require "rails_helper"

shared_context "form answers table sorting" do
  context "Company/Nominee" do
    let(:header_position) { subject.is_a?(Admin) ? 0 : 1 }
    let(:asc_company_names) do
      FormAnswer.pluck(:company_or_nominee_name).sort
    end

    context "by default" do
      it "sorts by Company/Nominee column ascending" do
        expect(column_values(header_position)).to eq(asc_company_names)
      end
    end

    it "sorts by Company/Nominee header" do
      click_header("Company/Nominee")
      expect(column_values(header_position)).to eq(asc_company_names.reverse)

      click_header("Company/Nominee")
      expect(column_values(header_position)).to eq(asc_company_names)
    end
  end

  context "Reference header" do
    let(:header_position) { subject.is_a?(Admin) ? 1 : 2 }

    let(:asc_references) do
      FormAnswer.pluck(:urn).sort
    end

    it "sorts by reference header" do
      click_header("Reference")
      expect(column_values(header_position)).to eq(asc_references)
    end
  end
end

def column_values(column_number)
  within ".applications-table" do
    all("tbody tr").map do |tr|
      tr.all("td")[column_number].text
    end
  end
end

def click_header(name)
  find("th.sortable", text: name).find("a").click
end
