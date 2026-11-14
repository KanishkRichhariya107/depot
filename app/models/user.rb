class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/ }
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_mail
  before_destroy :prevent_admin_destruction
  before_update :prevent_admin_updation

  class Error < StandardError
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

  def send_welcome_mail
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  def prevent_admin_destruction
    if email_address == "admin@depot.com"
      errors.add(:base, "admin cant be destroyed")
      throw :abort
    end
  end

  def prevent_admin_updation
    if email_address_in_database == "admin@depot.com"
      errors.add(:base, "admin cant be updated")
      throw :abort
    end
  end
end
