require 'rails_helper'

RSpec.describe SendgridHelper do
  before do
    # SENDGRID RELATED STUBS - BEGIN
    stub_request(:get, "https://sendgrid.com/api/spamreports.get.json?api_key=test_smtp_password&api_user=test_smtp_username&email=test@example.com").
      to_return(status: 200, body: "", headers: {})

    stub_sendgrid_bounced_emails_check_request("test@irrelevant.com")
    stub_sendgrid_bounced_emails_check_request("test@example.com")
    # SENDGRID RELATED STUBS - END

    AwardYear.current
  end

  context 'with sendgrid configured' do
    around do |example|
      smtp_settings = Rails.configuration.action_mailer.smtp_settings
      Rails.configuration.action_mailer.smtp_settings = {
        user_name: 'test_smtp_username',
        password: 'test_smtp_password'
      }
      example.run
      Rails.configuration.action_mailer.smtp_settings = smtp_settings
    end

    context "spam reports" do
      context "error handling" do
        [Curl::Err::CurlError, JSON::ParserError].each do |exception_class|
          it "marks the email as valid if there's an error (#{exception_class})" do
            allow(Curl::Easy).to receive(:perform).and_raise(exception_class)
            expect(SendgridHelper.spam_reported?('test@example.com')).to be_falsey
          end
        end

        it "marks the email as valid when authentication fails" do
          allow(JSON).to receive(:parse).and_return({error: 'lol'})
          expect(SendgridHelper.spam_reported?('test@example.com')).to be_falsey
        end
      end

      context "when no error" do
        it "marks an e-mail as valid" do
          allow(JSON).to receive(:parse).and_return([])
          expect(SendgridHelper.spam_reported?('test@example.com')).to be_falsey
        end

        it "marks an e-mail as invalid" do
          api_response = [
            {
              'ip' => '174.36.80.219',
              'email' => 'test@example.com',
              'created' => '2009-12-06 15:45:08'
            }
          ]
          allow(JSON).to receive(:parse).and_return(api_response)
          expect(SendgridHelper.spam_reported?('test@example.com')).to be_truthy
        end
      end
    end

    context "bounced" do
      context "error handling" do
        [Curl::Err::CurlError, JSON::ParserError].each do |exception_class|
          it "marks the email as valid if there's an error (#{exception_class})" do
            allow(Curl::Easy).to receive(:perform).and_raise(exception_class)
            expect(SendgridHelper.bounced?('test@example.com')).to be_falsey
          end
        end

        it "marks the email as valid when authentication fails" do
          allow(JSON).to receive(:parse).and_return({error: 'lol'})
          expect(SendgridHelper.bounced?('test@example.com')).to be_falsey
        end
      end

      context "when no error" do
        it "marks an e-mail as valid" do
          allow(JSON).to receive(:parse).and_return([])
          expect(SendgridHelper.bounced?('test@example.com')).to be_falsey
        end

        it "marks an e-mail as invalid" do
          api_response = [
            {
              'status' => '4.0.0',
              'created' => '2011-09-16 22:02:19',
              'reason' => 'Unable to resolve MX host example.com',
              'email' => 'test@example.com'
            }
          ]
          allow(JSON).to receive(:parse).and_return(api_response)
          expect(SendgridHelper.bounced?('test@example.com')).to be_truthy
        end
      end
    end
  end

  context 'without sendgrid configured' do
    around do |example|
      smtp_settings = Rails.configuration.action_mailer.smtp_settings
      Rails.configuration.action_mailer.smtp_settings = {}
      example.run
      Rails.configuration.action_mailer.smtp_settings = smtp_settings
    end

    context 'bounced?' do
      it 'never says that the email has bounced' do
        expect(SendgridHelper.bounced?('test@example.com')).to be_falsey
      end
    end

    context 'spam_reported?' do
      it 'never says that the email address has been reported for spam' do
        expect(SendgridHelper.spam_reported?('test@example.com')).to be_falsey
      end
    end
  end

  context "sendgrid connection test" do
    let :host do
      'smtp.sendgrid.net'
    end

    let :port do
      587
    end

    context "when it connects" do
      it "will return true" do
        expect(Net::SMTP).to receive(:start)
        expect(SendgridHelper.smtp_alive?(host, port)).to be_truthy
      end
    end

    context "when it times out" do
      it "will return false" do
        expect(Net::SMTP).to receive(:start).and_raise(Net::OpenTimeout)
        expect(SendgridHelper.smtp_alive?(host, port)).to be_falsey
      end
    end

    context "when the port is closed" do
      it "will return false" do
        expect(Net::SMTP).to receive(:start).and_raise(Errno::ECONNREFUSED)
        expect(SendgridHelper.smtp_alive?(host, port)).to be_falsey
      end
    end

    context "when the hostname cannot be resolved" do
      it "will return false" do
        expect(Net::SMTP).to receive(:start).and_raise(SocketError)
        expect(SendgridHelper.smtp_alive?(host, port)).to be_falsey
      end
    end
  end
end
