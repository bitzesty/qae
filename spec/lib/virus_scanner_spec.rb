require "rails_helper"

describe VirusScanner do
  let(:base_url) { "http://example.com" }
  let(:username) { "testuser" }
  let(:password) { "testpass" }
  let(:file_path) { "/path/to/test/file.txt" }
  let(:file_content) { "file content" }

  before do
    VirusScanner.configure(base_url: base_url, username: username, password: password)
  end

  describe ".configure" do
    it "sets the base_url, username, and password" do
      expect(VirusScanner.base_url).to eq(base_url)
      expect(VirusScanner.username).to eq(username)
      expect(VirusScanner.password).to eq(password)
    end
  end

  describe ".scan_file" do
    let(:uri) { URI.join(base_url, "/v2/scan-chunked") }
    let(:http_response) { instance_double(Net::HTTPResponse) }
    let(:http) { instance_double(Net::HTTP) }
    let(:temp_file) { instance_double(Tempfile, close: nil, unlink: nil, path: "/tmp/virus_scan") }

    before do
      allow(Tempfile).to receive(:new).and_return(temp_file)
      allow(temp_file).to receive(:write)
      allow(temp_file).to receive(:rewind)
      allow(File).to receive(:open).with(file_path, "rb").and_yield(StringIO.new(file_content))
      allow(IO).to receive(:copy_stream)
      allow(Net::HTTP).to receive(:start).and_yield(http)
      allow(http).to receive(:request).and_return(http_response)
      allow_any_instance_of(Net::HTTP::Post).to receive(:body_stream=)
    end

    context "when the scan is successful and no malware is found" do
      let(:response_body) { '{"malware": false, "reason": null, "time": 0.16444095800397918}' }

      before do
        allow(http_response).to receive(:code).and_return("200")
        allow(http_response).to receive(:body).and_return(response_body)
      end

      it "returns the parsed scan result" do
        result = VirusScanner.scan_file(file_path)
        expect(result).to eq({ malware: false, reason: nil, scan_time: 0.16444095800397918 })
      end
    end

    context "when the scan is successful and malware is found" do
      let(:response_body) { '{"malware": true, "reason": "Win.Test.EICAR_HDB-1", "time": 0.24377495900262147}' }

      before do
        allow(http_response).to receive(:code).and_return("200")
        allow(http_response).to receive(:body).and_return(response_body)
      end

      it "returns the parsed scan result with malware details" do
        result = VirusScanner.scan_file(file_path)
        expect(result).to eq({ malware: true, reason: "Win.Test.EICAR_HDB-1", scan_time: 0.24377495900262147 })
      end
    end

    context "when the request is invalid" do
      before do
        allow(http_response).to receive(:code).and_return("400")
      end

      it "raises a BadRequestError" do
        expect { VirusScanner.scan_file(file_path) }.to raise_error(VirusScanner::BadRequestError, "Invalid request: None or more than one file specified")
      end
    end

    context "when authentication fails" do
      before do
        allow(http_response).to receive(:code).and_return("401")
      end

      it "raises an AuthenticationError" do
        expect { VirusScanner.scan_file(file_path) }.to raise_error(VirusScanner::AuthenticationError, "Invalid credentials")
      end
    end

    context "when the file is too large" do
      before do
        allow(http_response).to receive(:code).and_return("413")
      end

      it "raises a FileTooLargeError" do
        expect { VirusScanner.scan_file(file_path) }.to raise_error(VirusScanner::FileTooLargeError, "File is too large (max 1GB)")
      end
    end

    context "when an unexpected server error occurs" do
      before do
        allow(http_response).to receive(:code).and_return("500")
      end

      it "raises a ScanError" do
        expect { VirusScanner.scan_file(file_path) }.to raise_error(VirusScanner::ScanError, "Unexpected server error")
      end
    end
  end
end
