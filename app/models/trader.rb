class Trader < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  after_create :send_email
  def send_email
    UserMailer.registration(email).deliver_now if is_approved==false
    UserMailer.welcome_email(email).deliver_now if is_approved==true
  end

  def active_for_authentication?
    super && is_approved?
  end

  def inactive_message
    is_approved? ? super : :not_approved
  end
end
