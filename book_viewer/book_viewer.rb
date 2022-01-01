require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

not_found do
  redirect "/"
end

helpers do

  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end

  def find_chapters
    value = params[:query]
    results = []
    @contents.each_with_index do |chapter_name, index|
      current_chapter = File.read("data/chp#{index + 1}.txt")
      if current_chapter.include?(value)
        results << (index + 1)
      end
    end
    results
  end

end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  chapter_number = params[:number].to_i
  chapter_title = @contents[chapter_number - 1]

  redirect "/" unless (1..@contents.size).cover?(chapter_number)

  @title = "Chapter #{chapter_number}: #{chapter_title}"
  @chapter = File.read("data/chp#{params[:number]}.txt")
 
  erb :chapter
end

get "/show/:name" do
    params[:name]
end

get "/search" do
  @title = "Search"
  erb :search
end

