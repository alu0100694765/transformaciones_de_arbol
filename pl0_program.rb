require 'data_mapper'
# full path!
DataMapper.setup(:default, 
                 ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db" )

class PL0Program
  include DataMapper::Resource
  
  property :name, String, :key => true
  property :source, String, :length => 1..1024
  property :user, String, :length => 1..1024
  property :provider, String, :length => 1..1024
  property :create_at, DateTime, :default => Time.now
  property :nuses,     Integer,  :default => 1
  
end

DataMapper.finalize
DataMapper.auto_upgrade!


