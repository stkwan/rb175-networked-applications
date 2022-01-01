require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

not_found do
  redirect "/"
end

before do
  @contents = YAML.load_file("users.yaml")
end

helpers do
  def get_total_interests
    sum = 0
    @contents.each do |_, info|
      sum += info[:interests].size
    end
    sum
  end
  
end

get "/" do
  @title = "Users and Interests"
  erb :home
end

get "/:name" do
  redirect "/" unless @contents.keys.include?(params[:name].to_sym)

  @title = params[:name].capitalize
  @name = params[:name].to_sym
  @email = @contents[@name][:email]
  @interests = @contents[@name][:interests]

  erb :user_profile
end
