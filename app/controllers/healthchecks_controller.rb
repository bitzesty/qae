class HealthchecksController < ApplicationController
  def show
    error = nil
    begin
      ActiveRecord::Migration.check_pending!
    rescue ActiveRecord::PendingMigrationError => ex
      error = ex.message
    end
    if error
      render text: "error: #{error}"
    else
      render text: "success"
    end
  end
end
