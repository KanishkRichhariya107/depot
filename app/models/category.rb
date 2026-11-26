class Category < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id }, if: -> { name.present? }
  validate :no_nesting_present
  belongs_to :parent, class_name: "Category", optional: true
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_id"
  has_many :products, dependent: :restrict_with_error
  has_many :sub_category_products, through: :sub_categories, source: :products, dependent: :destroy
  before_destroy :check_products
  def no_nesting_present
    if parent.present? && parent.parent_id.present?
      errors.add(:parent_id, "its parent is a child of another category")
    end
  end
  def recalculate_products_count
    total = products.count + sub_category_products.count
    update_column(:products_count, total)
  end
end
