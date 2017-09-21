require 'sequel'
require 'yaml'

dbLink = YAML.load(File.open('.\config\config.yml'))

DB = Sequel.connect(constructURL)
DB.run("create table t (a text, b text)")

def constructURL()
    url =   dbLink['adapter']
            + "://"
            + dbLink['user']
            + ":" 
            + dbLink['password']
            + "@" 
            + dbLink['host']
            + ":" 
            + dbLink['port'].to_s 
            + "/" 
            + dbLink['database']
end