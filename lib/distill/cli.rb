#note that back when we put this class CLI inside the Distill module
#we just define it as class cli
#but here it's in a seprate file. so things change.
#i'm not exactly sure the way things work. i'm just parroting and pryaing it works
#apparently putting in like this creates the same effect as if you phsyically put it inside the module
#even though it's not, its in a seprate file

class Distill::CLI

  def initialize
    Distill::Genre.addthegenres()
    #if u add too much at initalize, it slows down the app. but i think here it take same amount either way
  end

  def call
    #this is the "HomePage"
    puts "Hello World"
    puts "Type quit anytime to quit the app"
    list_genres
    process_genrechoice
    say_goodbye
  end

  def list_genres
    Distill::Genre.list_genre_names()
    end



  def say_goodbye
    puts "Bye. Thanks for using our app."
  end

  def display_books_in_genre(genre)
    #aka display books in genre
    #takes the argument of the genre instance and then display books in that genres
    #u only need to fetch it once. make sure this happen properly
    puts genre.name
    puts genre.genrelink
    #scrape the books with scraper tool
    Distill::Scraper.new.books_in_genre(genre)
    #display the books:
    Distill::Genre.display_books_of_genre(genre)

  end

  def display_book_detail(book)
    puts "Title: #{book.title}"
    puts "Genre: #{book.genre}"
    puts "Author: #{book.authorname}"
    puts "Pages: #{book.pages}"
    puts "Publish Date: #{book.publishdate}"
    puts "Amazon Link: #{book.amazonlink}"
    puts "Description: #{book.description}"
  end

  def process_bookchoice(genre)
    #context: user choose a number from a list of 15 books in that genres (from display_genre method)
    #and the task here is to display the details
    #besides the number, we need to figure out the context of the list of choices that was displayed
    #that is needed so that we can figure out what book the user wants
    #to figure out the context, we'll just ask the genre, we won't ask the for the list, we'll get the source of the list ourselves
    #cuz we don't want to have code read the list and understand what it means and search it up it's a mess
    input = nil
    puts "type the number of the book u want"
    while input != "quit"
      input = gets.strip

      if input.to_i > 0 && input.to_i < 16 #we're strict so we don't run into nil error
        #figure out what book the user chose:
        book = Distill::Genre.books_of_genre(genre)[input.to_i - 1]
        puts "the book we think the user chose is: #{book.title}"
        # Distill::Genre.display_books_of_genre called in display_books_in_genre actually uses this method above to get its list before it display, so the order should be the same
        #that is, unless there was a change in the moment jsut before. which shouldn't happen. becasue this app doesn't update anything automatically on itself
        #fetch more details on that book:
          Distill::Scraper.new.book_detail(book)
          #this should update the book with more details
        #display the book pseudo code:
          display_book_detail(book)
        #process_bookchoice()
        return
      elsif input == "quit"
        return
      else
        puts "invalid input. please re-enter"
      end #end if

    end #end loop
end #end method



  def process_genrechoice
    input = nil
    puts "type the number of the GENRE you want"
    while input != "quit"
      input = gets.strip

      if input.to_i > 0 && input.to_i < Distill::Genre.all.size
        #fetch the books in that genre
        genre = Distill::Genre.all[input.to_i - 1] #returns genre instance
        display_books_in_genre(genre)
        process_bookchoice(genre) #this will ask for input and process it


        #challenge: we need to make the order listed predictable somehow
        #at the very least they must sync, if user want book 1 we better get the right book...

        process_genrechoice()
        return




      # if input == "1"
      #   puts "1. abc"
      #   process_choice()
      #   return #gotta put return otherwise u'll be doing nothing
      #   #cuz u have many recursive loop, but the outerloop still doesn't have the input = exit, only input of the inner loops are exit
      # elsif input == "2"
      #   puts "2. def"
      #   process_choice()
      #   return #gotta put return otherwise u'll be doing nothing
    elsif input == "quit"
        return
      else
        puts "invalid input. please re-enter"
      end #end if

    end #end loop
end #end method

end
