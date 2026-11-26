class Product < ApplicationRecord
  belongs_to :category, counter_cache: true
  has_one_attached :image
  has_many :line_items, dependent: :restrict_with_error
  # before_destroy :ensure_not_referenced_by_any_line_item
  has_many :carts, through: :line_items
  after_commit -> { broadcast_refresh_later_to "products" }
  validates :title, :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }, price_greater_than_equal_discount_price: true
  validates :title, uniqueness: true
  validate :acceptable_image
  validates :permalink, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+){2,}\z/, message: "must contain at least 3 words with hyphens in between" }
  validate :description_length
  # validate :price_greater_than_equal_discount_price
  # validates :price, comparison: { greater_than_or_equal_to: :discount_price }, if: -> { price.present? && discount_price.present? }
  before_validation :set_default_title
  before_validation :set_discount_price_equals_to_price
  scope :enabled_products, -> { where(enabled: true) }
  scope :in_atleast_one_line_item, -> { where.associated(:line_items).distinct }

  def self.titles_in_atleast_one_line_item
    in_atleast_one_line_item.pluck(:title)
  end

  after_create :update_parent_count
  after_destroy :update_parent_count
  after_update :update_parent_count, if: :saved_change_to_category_id?

  def update_parent_count
    ids = [category_id]

    if saved_change_to_category_id?
      ids << saved_change_to_category_id.first
    end

    ids.compact.uniq.each do |id|
      category = Category.find(id)
      next unless category
      category.recalculate_products_count
      category.parent.recalculate_products_count
    end
  end

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

  def price_greater_than_equal_discount_price
    unless price.blank?|| discount_price.blank?||price >= discount_price
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
