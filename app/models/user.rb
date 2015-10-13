require 'openssl'
MAX_USERNAME_LENGTH = 50
MIN_USERNAME_LENGTH = 2
MAX_EMAIL_LENGTH = 255
#MIN_EMAIL_LENGTH is not definrd cause i don't realy whant to know and it's anyway checked through regular expressions
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
VALID_USER_REGEX = /\A[\w+\-@. ]+\z/i
class User < ActiveRecord::Base
	before_save do 
		self.email = email.squish().downcase
		name = self.name.squish()
		self.name = name
		#grants caseless nameuniquness but keeps original name in other column
		#do I need insex on original name column?
		self.downame = name.downcase
	end

	validates :name,  presence: true, length: { maximum: MAX_USERNAME_LENGTH,  minimum: MIN_USERNAME_LENGTH},
		format: { with: VALID_USER_REGEX }, uniqueness: { case_sensitive: false }
	validates :email, presence: true, length: { maximum: MAX_EMAIL_LENGTH },
		format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 64, maximum: 64}

	has_secure_password

    #will need to refactor and probably rebuild some of encription and other stuff some of it should be placed in helpers
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

	def has_pass?
		if password and password.length == 64
			digest = OpenSSL::Digest.new('sha256')
			hash = OpenSSL::HMAC.digest(digest, name, "").unpack('H*')[0]
			return password == hash
		end
		return false
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
		@@users[self.name.downcase] = self;
		@@usersbymail[self.email.downcase] = self;
	end

	def has_name?()
		return !name.blank?
	end

	def long_enough_name?()
		return name.length >= MIN_USERNAME_LENGTH
	end

	def valid_name?()
		return VALID_USER_REGEX.match(name)
	end

	def short_enough_name?()
		return name.length <= MAX_USERNAME_LENGTH
	end

	def short_enough_email?()
		return email.length <= MAX_EMAIL_LENGTH
	end

	def has_email?()
		return !email.blank?
	end

	def valid_email?()
		return VALID_EMAIL_REGEX.match(email)
	end

	def unique_name?()
		return @@users[self.name.downcase].nil?
	end

	def unique_email?()
		return @@usersbymail[self.email.downcase].nil?
	end
end
