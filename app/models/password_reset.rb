#TODO: remove old records from db
#TODO: remove used records from db
class PasswordReset < ActiveRecord::Base
	include HasSecurityToken
end
