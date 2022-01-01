require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

not_found do
  redirect "/"
end

helpers do

  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=\"paragraph#{index}\">#{line}</p>"
    end.join
  end

  def each_chapter
    @contents.each_with_index do |chapter_name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, chapter_name, contents
    end
  end

  def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
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
  @results = chapters_matching(params[:query])
  erb :search
end

