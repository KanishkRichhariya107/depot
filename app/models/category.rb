class Category < ApplicationRecord
  before_destroy :check_products, prepend: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id }, if: -> { name.present? }
  validate :no_nesting_present
  belongs_to :parent, class_name: "Category", optional: true
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :sub_category_products, through: :sub_categories, source: :products

  def recalculate_products_count
    total = products.count + sub_category_products.count
    update_column(:products_count, total)
  end

  private

  def check_products
    return unless sub_category_products.exists?

    errors.add(:base, "Cannot delete: a sub-category still has products")
    throw :abort
  end

  def no_nesting_present
    return if parent.nil?

    if parent_id == id
      errors.add(:parent, "can't be the category itself")
    elsif parent.parent_id.present?
      errors.add(:parent, "is already a sub-category")
    elsif sub_categories.exists?
      errors.add(:parent, "can't be set because this category has sub-categories")
    end
  end
end
