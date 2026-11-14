class Product < ApplicationRecord
  has_one_attached :image
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  after_commit -> { broadcast_refresh_later_to "products" }
  validates :title, :description, :image, presence: true
  validates :price, numericality: true, allow_blank: true
  validates :title, uniqueness: true
  validate :acceptable_image
  validates :permalink, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+){2,}\z/, message: "must contain at least 3 words with hyphens in between" }
  validate :description_length
  # validate :price_greater_than_discount_price
  validates :price, comparison: { greater_than: :discount_price }, if: -> { price.present? && discount_price.present? }

  after_initialize :set_default_title
  before_validation :set_discount_price_equals_to_price
  def acceptable_image
    return unless image.attached?

    acceptable_type = [ "image/gif", "image/jpeg", "image/png" ]

    unless acceptable_type.include?(image.blob.content_type)
      errors.add(:image, "must be a GIF, JPG or PNG image")
    end
  end

  def description_length
    words = description.to_s.split.length
    unless words.between?(5, 10)
      errors.add(:description, "must be between 5 to 10 words ")
    end
  end

  def price_greater_than_discount_price
    unless price.blank?|| discount_price.blank?||price > discount_price
      errors.add(:price, "must be greater than discount price")
    end
  end

  private

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "line items present")
      throw :abort
    end
  end

  def set_default_title
    self.title = "abc" if title.blank?
  end

  def set_discount_price_equals_to_price
    self.discount_price = price if discount_price.nil?
  end
end
