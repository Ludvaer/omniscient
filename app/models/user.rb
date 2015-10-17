require 'openssl'
MAX_USERNAME_LENGTH = 50
MIN_USERNAME_LENGTH = 2
MAX_EMAIL_LENGTH = 255
#MIN_EMAIL_LENGTH is not definrd cause i don't realy whant to know and it's anyway checked through regular expressions
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
VALID_USER_REGEX = /\A[\w+\-@. ]+\z/i
PASSWORD_LENGTH = 64
class User < ActiveRecord::Base
	before_save do 
		email.squish!.downcase!
		self.name.squish!
		self.name = name
		#grants caseless nameuniquness but keeps original name in other column
		#do I need insex on original name column?
		self.downame = name.downcase
	end

	validates :name,  presence: true, length: { maximum: MAX_USERNAME_LENGTH,  minimum: MIN_USERNAME_LENGTH},
		format: { with: VALID_USER_REGEX }, uniqueness: { case_sensitive: false }
	validates :email, presence: true, length: { maximum: MAX_EMAIL_LENGTH },
		format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: PASSWORD_LENGTH, maximum: PASSWORD_LENGTH}
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
		if password and password.length == PASSWORD_LENGTH
			return password == hash_pass('')
		end
		return false
	end

	def hash_pass(pass)
		digest = OpenSSL::Digest.new('sha256')
		return OpenSSL::HMAC.digest(digest, name.downcase, pass).unpack('H*')[0]
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
	#	@@users[self.name.downcase] = self;
	#	@@usersbymail[self.email.downcase] = self;
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

	def has_email?
		return !email.blank?
	end

	def valid_email?
		return VALID_EMAIL_REGEX.match(email)
	end


	def check_unique(users)
		if id
			return ((users.length == 0) or ((users.length == 1) and (id == users[0].id)))
		else
			return (users.length == 0)
		end
	end

	def unique_name?
		#return @@users[self.name.downcase].nil?
		check_unique User.where(downame: name.squish().downcase)
	end

	def unique_email?
		#return @@usersbymail[self.email.downcase].nil?
		check_unique User.where(email: email.squish().downcase) 
	end
end
