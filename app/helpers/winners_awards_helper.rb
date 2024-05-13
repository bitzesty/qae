module WinnersAwardsHelper
  def static_s3_asset_path(year, file_name)
    file_path = "winners assets #{year}/#{file_name}"

    "https://s3-eu-west-1.amazonaws.com/qae-winners-assets/#{CGI.escape(file_path)}"
  end
end
