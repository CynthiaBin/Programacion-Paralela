require 'yaml'


class Helper

    dbLink = YAML.load(File.open('.\config\config.yml'))
    
    def self.constructURL()
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
end