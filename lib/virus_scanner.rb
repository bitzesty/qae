require "net/http"
require "uri"
require "json"
require "tempfile"

class VirusScanner
  class << self
    attr_accessor :base_url, :username, :password

    def configure(base_url:, username:, password:)
      @base_url = base_url
      @username = username
      @password = password
    end

    def scan_file(file)
      return { malware: false, reason: nil, scan_time: 0 } if ENV["DISABLE_VIRUS_SCANNER"] == "true"

      uri = URI.join(@base_url, "/v2/scan-chunked")
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(@username, @password)
      request["Content-Type"] = "application/octet-stream"
      request["Transfer-Encoding"] = "chunked"

      temp_file = download_to_tempfile(file)
      begin
        request.body_stream = temp_file
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end

        handle_response(response)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    private

    def download_to_tempfile(file)
      temp_file = Tempfile.new("virus_scan", encoding: "UTF-8")
      if file.is_a?(String)
        File.open(file, "rb") do |f|
          IO.copy_stream(f, temp_file)
        end
      elsif file.class.to_s.include?("Uploader")
        IO.copy_stream(StringIO.new(file.read), temp_file)
      elsif file.respond_to?(:read)
        IO.copy_stream(file, temp_file)
      elsif file.respond_to?(:file)
        if file.file.respond_to?(:path)
          File.open(file.file.path, "rb") do |f|
            IO.copy_stream(f, temp_file)
          end
        elsif file.file.respond_to?(:read)
          temp_file.write(file.file.read)
        else
          raise ArgumentError, "Don't know how to handle #{file.file.class}"
        end
      elsif file.respond_to?(:path)
        File.open(file.path, "rb") do |f|
          IO.copy_stream(f, temp_file)
        end
      else
        raise ArgumentError, "Unsupported file type: #{file.class}"
      end
      temp_file.rewind
      temp_file
    end

    def handle_response(response)
      case response.code.to_i
      when 200
        parse_scan_result(response.body)
      when 400
        raise BadRequestError, "Invalid request: None or more than one file specified"
      when 401
        raise AuthenticationError, "Invalid credentials"
      when 413
        raise FileTooLargeError, "File is too large (max 1GB)"
      when 500
        raise ScanError, "Unexpected server error"
      else
        raise ScanError, "Unexpected error: #{response.code} #{response.message}"
      end
    end

    def parse_scan_result(body)
      result = JSON.parse(body)
      {
        malware: result["malware"],
        reason: result["reason"],
        scan_time: result["time"],
      }
    end
  end

  class BadRequestError < StandardError; end

  class AuthenticationError < StandardError; end

  class FileTooLargeError < StandardError; end

  class ScanError < StandardError; end
end
