require 'openssl'
class User < ActiveRecord::Base
	@@sym = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    @@rsa_key = OpenSSL::PKey::RSA.new(2048)
    @@ssl = "asdfasdfasdfasdf"
	
	def self.key
		@@rsa_key.public_key
	end

	def self.salt
		l = @@sym.length
		(0...50).map { @@sym[rand(l)] }.join
	end
end
