require 'bcrypt'
class User < ApplicationRecord
    # attr_accessor :encrypted_password
    # attr_accessor :username, :email, :password, :password_confirmation
    EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
    # /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
    validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
    validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
    validates :encrypted_password, :confirmation => true, :length => {:within => 6..40}, :on => :create
    # validates_length_of :password, :in => 6..20, :on => :create
    before_save :encrypt_password
    after_save :clear_password
    def encrypt_password
        if encrypted_password.present?
            self.salt = BCrypt::Engine.generate_salt
            self.encrypted_password= BCrypt::Engine.hash_secret(encrypted_password, salt)
        end
    end
    def clear_password
        self.encrypted_password = nil
    end
    def self.authenticate(name_or_email="", login_password="")
        if  EMAIL_REGEX.match(name_or_email)    
             user = User.find_by_email(name_or_email)
        else
             user = User.find_by_name(name_or_email)
        end
        if user && user.match_password(login_password)
            return user
        else
            return false
        end
    end   
    def match_password(login_password="")
        encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
    end
end
