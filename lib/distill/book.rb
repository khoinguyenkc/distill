class Distill::Book
  attr_accessor :authorname, :pages, :publishdate, :description, :amazonlink
  attr_reader :title, :link, :genre
  @@all = []
  def initialize(title, link = "", genre = "")
    @title = title
    @link = link
    @genre = genre
    @@all << self
  end

  def self.all
    @@all
  end

end
