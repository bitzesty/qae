# Example of use:
# form = FormAnswer.find(1123)
# FormDataGoodsAndServicesRestorer.new(form).run
# ------------------------------
# [1123] amount: 1, found amout: 1
#    new_data: [{"desc_short"=>"Design, manufacture and service of laboratory gas generators.", "total_overseas_trade"=>"100%"}, {"desc_short"=>"", "total_overseas_trade"=>""}, {"desc_short"=>"", "total_overseas_trade"=>""}, {"desc_short"=>"", "total_overseas_trade"=>""}, {"desc_short"=>"", "total_overseas_trade"=>""}]
# ------------------------------

class FormDataGoodsAndServicesRestorer

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def run
    latest_version = form.versions.select do |v|
      v.object.present? &&
      v.object["document"]["trade_goods_and_services_explanations"].present?
    end.last

    amount = form.document['trade_goods_amount']
    new_data = latest_version.object["document"]["trade_goods_and_services_explanations"]
    new_amount = new_data.select { |s| s["total_overseas_trade"].present? }.count

    puts "------------------------------"
    puts "[#{form.id}] amount: #{amount}, found amout: #{new_amount}"
    puts "   new_data: #{new_data}"
    puts "------------------------------"

    # form.document["trade_goods_and_services_explanations"] = new_data
    # form.save!
  end

  class << self
    def bad_forms
      FormAnswer.submitted
                .for_award_type("trade")
                .select do |f|
        f.document["trade_goods_and_services_explanations"].present? &&
        f.document["trade_goods_and_services_explanations"].all? do |g|
          g["desc_short"].blank?
        end
      end
    end
  end
end
