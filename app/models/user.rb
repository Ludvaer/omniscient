require 'openssl'
class User < ActiveRecord::Base
	@@sym = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    @@rsa_key = OpenSSL::PKey::RSA.new(2048)
    @@ssl = "asdfasdfasdfasdf"
    @@salts = {}
    @@i = 1
	def self.key
		@@rsa_key.public_key
	end

	def self.decrypt(password)
		p password
		a = @@rsa_key.private_decrypt([password].pack('H*'))
		p a
	end

	def self.salt

		l = @@sym.length
		salt = (0...5).map { @@sym[rand(l)] }.join + "#{@@i}"
		@@i += 1
		@@salts[salt] = true
		salt
	end


end
