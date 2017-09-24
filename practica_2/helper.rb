require 'yaml'
# Help
class Helper

    
    
    def self.constructURL()
        dbLink = YAML.load(File.open('.\config\config.yml'))

        url =   (dbLink['adapter']
                + "://"
                + dbLink['user']
                + ":@" 
                + dbLink['host']
                + ":" 
                + dbLink['port'].to_s 
                + "/" 
                + dbLink['database'])
        puts"#{url}"
    end 
end