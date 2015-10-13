require 'openssl'
MAX_USERNAME_LENGTH = 50
MIN_USERNAME_LENGTH = 2
MAX_EMAIL_LENGTH = 255
#MIN_EMAIL_LENGTH is not definrd cause i don't realy whant to know and it's anyway checked through regular expressions
class User < ActiveRecord::Base
	validates :name,  presence: true, length: { maximum: MAX_USERNAME_LENGTH,  minimum: MIN_USERNAME_LENGTH}
	validates :email, presence: true, length: { maximum: MAX_EMAIL_LENGTH}


	@@sym = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    @@rsa_key = OpenSSL::PKey::RSA.new(2048)
    @@ssl = "asdfasdfasdfasdf"
    @@salts = Hash.new(false)
    @@users = Hash.new(nil)
    @@usersbymail = Hash.new(nil)
    @@i = 1
	def self.key
		@@rsa_key.public_key
	end

	def self.decrypt(password)
		@@rsa_key.private_decrypt([password].pack('H*'))
	end

	def self.salt
		l = @@sym.length
		salt = (0...5).map { @@sym[rand(l)] }.join + "#{@@i}"
		@@i += 1
		@@salts[salt] = true
		#p "@@salts[#{salt}] = #{@@salts[salt]}"
		salt
	end

	def self.checksalt(salt)
		#p "@@salts[#{salt}] = #{@@salts[salt]}"
		if @@salts[salt]
			@@salts[salt] = false
			return true
		else
			return false
		end
	end

	def pseudosave()
		@@users[self.name] = self;
		@@usersbymail[self.email] = self;
	end

	def has_name?()
		return !name.blank?
	end

	def long_enough_name?()
		return name.length >= MIN_USERNAME_LENGTH
	end

	def short_enough_name?()
		return name.length <= MAX_USERNAME_LENGTH
	end

	def short_enough_mail?()
		return name.length <= MAX_EMAIL_LENGTH
	end

	def has_email?()
		return !email.blank?
	end

	def unique_name?()
		return @@users[self.name].nil?
	end

	def unique_email?()
		return @@usersbymail[self.email].nil?
	end
end
