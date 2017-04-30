class Domain < Sequel::Model(:domains)
  # id | name
end

class User < Sequel::Model(:users)
  # id | mail | password
end

class Alias < Sequel::Model(:aliases)
  # id | source | destination
end

