class SPDatabase

    # a bunch of sql
    @@db = Database.new

    def initialize(name)
        @name = name
        @@
    end

    def insert
    end

    def update
    end

    def delete
    end

    def save
    end

    def create_table(name)
        sql = "CREATE TABLE ?"
        @@db.execute(sql, name)
    end

    


end

