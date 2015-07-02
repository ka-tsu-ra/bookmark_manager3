require 'bcrypt'


class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  # validates_confirmation_of is a DataMapper method
  # provided especially for validating confirmation passwords!
  # The model will not save unless both password
  # and password_confirmation are the same
  # read more about it in the documentation
  # http://datamapper.org/docs/validations.html
  validates_confirmation_of :password

  property :id, Serial
  property :email, String, unique: true, message: 'This email is already taken'

  property :password_digest, Text
  property :password_token, Text

  def password=(password)
    @password = password  # without this the password attribute would always be nil.
    self.password_digest = BCrypt::Password.create(password)
  end


  def self.authenticate(email:, password:)
    user = first(email: email)  # FINDS FIRST ENTRY IN USER TABLE THAT HAS EMAIL MATCHING THE EMAIL PARAMETER PASSED IN IN THIS METHOD.
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def self.reset_password(email)
    user = first(email: email) # find the record of the user that's recovering the password
    user.update(:password_token => "ASDADADS")
    user.save
  end

  def token=(token)
    @password_token = token
  end

end
