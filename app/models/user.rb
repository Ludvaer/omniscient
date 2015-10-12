require 'openssl'
class User < ActiveRecord::Base
    @@rsa_key = OpenSSL::PKey::RSA.new(2048)
    @@ssl = "asdfasdfasdfasdf"
	
	def self.key
		@@rsa_key.public_key
	end
end
