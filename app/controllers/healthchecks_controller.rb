class HealthchecksController < ApplicationController
  def show
    render text: ActiveRecord::Migrator.current_version
  end
end
