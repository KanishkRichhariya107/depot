class Product < ApplicationRecord
  has_one_attached :image
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  after_commit -> { broadcast_refresh_later_to "products" }
  validates :title, :description, :image, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validate :acceptable_image
  def acceptable_image
    return unless image.attached?

    acceptable_type = ["image/gif", "image/jpeg", "image/png"]

    unless acceptable_type.include?(image.content_type)
      errors.add(:image, "must be a GIF, JPG or PNG image")
    end
  end

  private

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "line items present")
      throw :abort
    end
  end
  
end
