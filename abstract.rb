require 'helper'

DB = Sequel.connect(Helper.constructURL)

class abstractBase

    def intialized(*data)
        @alias = data[0]
        @name = data[1]
        @link =data[2]
    end

    def register
        dataSet = DB[:table]
        dataset.insert(alias: @alias, name: @name, link: @link)
    end

    def by_id(id)
        dataSet = DB[:table]
        dataset.select(alias: @alias, name: @name, link: @link)
    end

    def list_all
    end

    def by_name
    end

    

end
