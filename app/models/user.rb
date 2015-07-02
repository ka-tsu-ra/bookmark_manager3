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

  def password=(password)
    @password = password  # without this the password attribute would always be nil.
    self.password_digest = BCrypt::Password.create(password)
  end

end
