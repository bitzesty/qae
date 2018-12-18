class HealthchecksController < ApplicationController
  def show
    error = nil
    begin
      ActiveRecord::Migration.check_pending!
    rescue ActiveRecord::PendingMigrationError => ex
      error = ex.message
    end
    if error
      render plain: "error: #{error}"
    else
      render plain: "success"
    end
  end
end
