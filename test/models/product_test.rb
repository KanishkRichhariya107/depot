
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image].any?
  end

  test "product price must be positive" do
    product = Product.new(
      title: "My Book Title",
      description: "Learn Ruby"
    )
    product.image.attach(
      io: File.open("db/images/ruby5.jpg"),
      filename: "ruby5.jpg",
      content_type: "image/jpeg"
    )
    product.price = -1
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product(filename, content_type)
    Product.new(
      title: "My Book Title",
      description: "Learn Ruby",
      price: 1
    ).tap do |product|
      product.image.attach(
        io: File.open("test/fixtures/files/#{filename}"),
        filename: filename,
        content_type: content_type
      )
    end
  end

  test "image type" do
    product = new_product("ruby5.jpg", "image/jpeg")
    assert product.valid?, "JPEG must be valid"
    product = new_product("logo.svg", "image/svg+xml")
    assert_not product.valid?, "SVG must be invalid"
  end

  test "product is not valid without a unique title" do
    product = Product.new(
      title: products(:pragprog).title,
      description: "yyy",
      price: 1
    )
    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"),
      filename: "lorem.jpg",
      content_type: "image/jpeg"
    )
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(
      title: products(:pragprog).title,
      description: "yyy",
      price: 1
    )

    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"),
      filename: "lorem.jpg",
      content_type: "image/jpeg"
    )

    assert product.invalid?
    assert_equal [I18n.translate("errors.messages.taken")],
                product.errors[:title]
  end
end
