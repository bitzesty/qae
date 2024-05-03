require "rails_helper"

RSpec.describe AdvancedEmailValidator do
  let :subject do
    AdvancedEmailValidator.new
  end

  let! :model do
    User.new
  end

  context "with bad e-mail address" do
    it "doesn't allow for a borked e-mail address" do
      expect do
        model.email = "@bad-email"
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end

    it "doesn't allow an empty e-mail address" do
      expect do
        model.email = ""
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end

    it "doesn't allow an address with a local part only" do
      expect do
        model.email = "jimmy.harris"
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end

    it "doesn't allow domains with a dot at the end" do
      expect do
        model.email = "feedback@domain.com."
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end

    it "doesn't allow domains with a dot at the beginning" do
      expect do
        model.email = "feedback@.domain.com"
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end
  end

  it "allows correct e-mail addresses" do
    pending "Sendgrid checks are disabled for now"
    expect(subject).to receive(:validate_dns_records).and_return(false)
    # expect(subject).to receive(:validate_spam_reporter).and_return(false)
    expect(subject).to receive(:validate_bounced).and_return(false)
    expect do
      model.email = "feedback@lol.biz.info"
      subject.validate(model)
    end.not_to(change { model.errors.empty? })
  end

  context "DNS checks for domain" do
    it "checks for the existence of an MX record for the domain" do
      pending "Sendgrid checks are disabled for now"
      expect_any_instance_of(Resolv::DNS).to receive(:getresource).and_raise(Resolv::ResolvError)
      expect do
        model.email = "test@gmail.co.uk"
        subject.validate(model)
      end.to(change { model.errors.empty? })
    end

    it "doesn't return an error when the MX lookup timed out" do
      pending "Sendgrid checks are disabled for now"
      expect_any_instance_of(Resolv::DNS).to receive(:getresource).and_raise(Resolv::ResolvTimeout)
      # expect(subject).to receive(:validate_spam_reporter).and_return(false)
      expect(subject).to receive(:validate_bounced).and_return(false)
      expect do
        model.email = "test@irrelevant.com"
        subject.validate(model)
      end.not_to(change { model.errors.empty? })
    end
  end

  # context "spam reporters" do
  #   it "prevents validation on an e-mail address marked as a spam reporter in sendgrid" do
  #     expect(subject).to receive(:validate_dns_records).and_return(false)
  #     expect(SendgridHelper).to receive(:spam_reported?).and_return(true)
  #     expect {
  #       model.email = 'test@irrelevant.com'
  #       subject.validate(model)
  #     }.to change { model.errors.empty? }
  #     expect(model.errors.first).to eq([:email, "cannot receive messages from this system"])
  #   end
  # end

  context "bounced addresses" do
    it "prevents validation on an e-mail address marked as bounced in sendgrid" do
      pending "Sendgrid checks are disabled for now"
      expect(subject).to receive(:validate_dns_records).and_return(false)
      # expect(subject).to receive(:validate_spam_reporter).and_return(false)
      expect(SendgridHelper).to receive(:bounced?).and_return(true)
      expect do
        model.email = "test@irrelevant.com"
        subject.validate(model)
      end.to(change { model.errors.empty? })
      expect(model.errors.first).to eq([:email, "cannot receive messages from this system"])
    end
  end
end
