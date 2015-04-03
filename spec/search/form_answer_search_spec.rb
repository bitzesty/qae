require "rails_helper"

describe FormAnswerSearch do
  it "filters by missing RSVP details" do
    admin = create(:admin)
    create(:form_answer)
    create(:form_answer)

    invite1 = create(:form_answer)
    invite1.create_palace_invite!

    invite2 = create(:form_answer)
    invite_with_rsvp = invite2.create_palace_invite!
    att = invite_with_rsvp.palace_attendees.build
    att.save(validate: false)
    scope = FormAnswer.all

    expect(FormAnswer.count).to eq(4)
    expect(PalaceAttendee.count).to eq(1)
    expect(PalaceInvite.count).to eq(2)

    res = described_class.new(scope, admin).filter_by_sub_status(scope, ["missing_rsvp_details"])
    expect(res.size).to eq(3)
    expect(res).to_not include(invite2)
    res = described_class.new(scope, admin).filter_by_sub_status(scope, [])
    expect(res.size).to eq(4)
    expect(res).to include(invite2)
  end
end
