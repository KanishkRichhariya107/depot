class PriceGreaterThanDiscountPriceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || record.discount_price.blank?

    if value <= record.discount_price
      record.errors.add(attribute, "must be greater than discount price")
    end
  end
end
