class Distill::Genre
  attr_reader :name
  attr_accessor :genrelink
 @@all = []
 @@genrelist = [
"Art", "Biography","Business","Children's","Christian","Classics","Comics","Cookbooks","Ebooks","Fantasy","Fiction","Graphic Novels","Historical Fiction","History","Horror","Memoir","Music","Mystery","Nonfiction","Poetry","Psychology","Romance","Science","Science Fiction","Self Help","Sports","Thriller","Travel","Young Adult"
]
@@genrelinks = [
"art", "biography","business","children-s","christian","classics","comics","cookbooks","ebooks","fantasy","fiction","graphic-novels","historical-fiction","history","horror","memoir","music","mystery","non-fiction","poetry","psychology","romance","science","science-fiction","self-help","sports","thriller","travel","young-adult"
]


 def initialize(name)
   @name = name
   #there should be some kind of name so that it created by accessed/looked up
   #perhaps each book should have a genre property
   #be careful of "grabbing" things, because a book might be severla genre
   #we have to think about at what point we assign genre
   #ther emight be a book that show up in severla genre lists
   #these should be made to be different instnaces? or we have books have the capacity to have diff genres?
   #right now i will be making multiple book instances
  @@all << self
end

def self.books_of_genre(genre)
  Distill::Book.all.select do | book |
    book.genre == genre
  end
  #return all books of this genre
end

def self.display_books_of_genre(genre)
  books = self.books_of_genre(genre)
  books.each_with_index do | book, index |
    puts "#{index+1}. #{book.title}"
  end
end


def self.find_genre_by_name(genrename) #class method
  #return the FIRST match, not all matches
  self.all.find { | instance | instance.name == genrename }
end

def self.addthegenres #class method
  #THIS METHOD IS MEANT TO BE CALLED ONCE

#   genrelist = [
# "Art", "Biography","Business","Children's","Christian","Classics","Comics","Cookbooks","Ebooks","Fantasy","Fiction","Graphic Novels","Historical Fiction","History","Horror","Memoir","Music","Mystery","Nonfiction","Poetry","Psychology","Romance","Science","Science Fiction","Self Help","Sports","Thriller","Travel","Young Adult"
# ]
# genrelinks = [
# "art", "biography","business","children-s","christian","classics","comics","cookbooks","ebooks","fantasy","fiction","graphic-novels","historical-fiction","history","horror","memoir","music","mystery","non-fiction","poetry","psychology","romance","science","science-fiction","self-help","sports","thriller","travel","young-adult"
# ]
  if @@genrelist != [] #this makes it a one-time method.
    @@genrelist.each_with_index do | genrename, index |
        newinstance = self.new(genrename)
        newinstance.genrelink = "https://www.goodreads.com/genres/#{@@genrelinks[index]}"
    end #end iteration
  end #end if
end #end method

def self.list_genre_names
  self.all.each_with_index do | genre, index |
    puts "#{index+1}. #{genre.name} "
  end

end #end method

def self.all
  @@all
end



end
