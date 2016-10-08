class Database
  attr :databaes

  def initialize path
    @filepath = path
    @database = {}
    read_database
  end

  def read_database
    if File.exists? @filepath
      @database = YAML::load_file(@filepath)
    else
      puts "run ruby init_database.rb"
    end
  end

  def save
    File.open(@filepath, 'w') { |f| YAML.dump(self.raw, f) }
  end

  def [] key
    @database[key]
  end
  alias_method :get, :[]

  def set key, val
    puts @database
    @database[key] = val
    save
    @database[key]
  end

  def raw
    @database
  end
end
