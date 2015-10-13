require 'openssl'
class User < ActiveRecord::Base
	validates :name,  presence: true
	validates :email, presence: true


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

	def hasName?()
		return !name.blank?
	end

	def hasEmail?()
		return !email.blank?
	end

	def uniqueName?()
		return @@users[self.name].nil?
	end

	def uniqueMail?()
		return @@usersbymail[self.email].nil?
	end
end
