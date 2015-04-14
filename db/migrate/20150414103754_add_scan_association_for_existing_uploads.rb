class AddScanAssociationForExistingUploads < ActiveRecord::Migration
  def change
    PopulateScanAssociationsForExistingAttachments.run
  end
end
