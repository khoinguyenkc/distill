class Distill::Scraper
  #scraper is a tool. not an object. so it doesn't store anything in some kind of @@all array
  #i'm gonna make the methods instance methods becuase it feels that way. like u feed it very diff things..
  #idk..
  def book_detail(bookinstance)
    #eventually we'll have this take premade book instance (made with title and link)
    #and we'll use the link to scrape other info and fill in.

    html = open('https://www.goodreads.com/book/show/45046808-big-lies-in-a-small-town')
    doc = Nokogiri::HTML(html) #retunrs xml nodeset

    authorname = doc.css("a.authorName").text
    #omg i'm so excited that this works! u can search by attribute
    pages = doc.css("div#details span[itemprop=\"numberOfPages\"]").text
    publishdate = (doc.css("div#details .row")[1].text).split("\n")[2].strip #this should say the date
    #that piece has really weird strucutre. spaces is asn item too. and u have to strip the space to make it look normal
    #lets hope this is stable across
    description = doc.css("div#description span")[1].text

    amazonlinktail =  doc.css("ul.buyButtonBar a#buyButton").attribute("href").value
    amazonlink =  addgoodreadsdotcom(amazonlinktail)
     #yes the link to amazon has a transfer link on goodred

    #i like to separate the task so that if i had to change css stuff, i can easily experiment neatly

    bookinstance.authorname = authorname
    bookinstance.pages = pages
    bookinstance.publishdate = publishdate
    bookinstance.description = description
    bookinstance.amazonlink = amazonlink


  end

  def addgoodreadsdotcom(linktail)
    link = "https://www.goodreads.com#{linktail}"
  end

  # def testing(genrelink)
  #   #we'll be given a page , like https://www.goodreads.com/genres/art
  #   #we'll scrape all the book titles and its link. 15 of them.
  #   #we want this to create 15 book instsances and make sure they are SAVED
  #
  #   html = open(genrelink)
  #   doc = Nokogiri::HTML(html) #retunrs xml nodeset
  #   allbigboxes = doc.css(".coverBigBox")
  #   puts allbigboxes.size
  #   allbigboxes.each do | box |
  #     puts box.css(".h2Container h2 a").text
  #   end
  # end

  def books_in_genre(genre)
    #we'll be given a page , like https://www.goodreads.com/genres/art
    #we'll scrape all the book titles and its link. 15 of them.
    #we want this to create 15 book instsances and make sure they are SAVED

    #gatekeeper: to prevent duplicates, check if books in this genre is already fetched.
    if Distill::Genre.books_of_genre(genre) != [] #cant do truthy falsey because empty array is truthy in ruby
      return
    end


    html = open(genre.genrelink)
    doc = Nokogiri::HTML(html) #retunrs xml nodeset
    genrename = doc.css(".genreHeader h1").text.strip
    puts "the genrename that was scraped is -#{genrename}-"
    if genrename == "Childrens"
      genrename = "Children's"
    end
    puts "new genrename is #{genrename}"
    #i'm fixing it manually because the url can be unreliable. say ...biography vs ...biography/
    #using a split tool can be complicated to deal with edge cases like that

    genre = Distill::Genre.find_genre_by_name(genrename)
    puts "did they find the genre in the list? the name found is #{genre.name}"
    #the genres were already added at the moment CLI class's list_options is called.
    #mostread = doc.css(".bigBoxBody")[1]
    allbigboxes = doc.css(".coverBigBox")
    mostread = allbigboxes.find do | box |
      box.css(".h2Container h2 a").text.include?("Most Read This Week")
    end
    #i used include because == doesn't work for many cases. it's not uniform. sometiems it's most read this week tagged Christian


    #the [0] index is not what we want. we just want the [1]
    #mostread only contains one "item" which is the bigboxbody we want
    books = mostread.css(".bookBox a")
    puts "how many books found in books = mostread.css.... #{books.size}"
    #this puts is really helpful for debugging. don't remove it

    #Distill::Genre.books_of_genre
    #we mut setup some how to only fetch books if they're not already fetched
    #to prevent duplicates
    #task NOT completed

    books.each do | book |
      title = book.css("img").attribute("alt").value
      booklink = addgoodreadsdotcom(book.attribute("href").value)
      #create a new book instance:
      Distill::Book.new(title, booklink, genre)
    end

    puts "how many books of this genre is added and recognized: #{Distill::Genre.books_of_genre(genre).size}"

    #puts Distill::Genre.books_of_genre(genre)[0]
    # Distill::Genre.books_of_genre(genre).each  do | book |
    #   puts book
    #   puts book.title
    # end



    #we want to seprate tasks. so this should only fetch the books in that genre. but not display it
    #display should be a method for Genre or Book



    #notice how to make this kind of structure, the thing we're looping (titles), need each title to be something that is a ROOT
    #for ex: the alt value of the img element. the img element is a child of the .bookBox a element. .booxBox a leement is a "root"
    #the href is also belongs to the .bookbox a element. otherwise we can't make use of the loop structure
    #metadata
    #when we scrape each element seprately, we don't have to think about that at all, but as a loop its very different!
    #so don't think if i got each element down, putting it in a loop is simple. no! gotta see what they have in common and "refactor"

    #puts title = mostread.css(".bookBox a img")[0].attribute("alt").value
    # attribute("alt").value
    #linktail = mostread.css(".bookBox a")[0].attribute("href").value
    #ex: /book/show/53991683-the-woman-in-the-moonlight
    #puts booklink = addgoodreadsdotcom(linktail)

    #how she we organize this?
    #we never want to have to scrape anything twice. so we save everything
    #tehre should be some kinda all that host different genres
    #each genres has 15 hashes of book title and links
    #as we use book_detail, we'll add to the 15 hashes other properties, like author, pages, etc
    #but i dont know how should we organize all this
    #in classes named genres and books?
    #apprently they want objects, which is instances of class, so we'll probably do that..
    #make it life-like i guess

    #we need to loop through each book. this might take more cleaning effort to loop through the right things


end



end
