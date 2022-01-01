# app.rb

require_relative 'advice'     # loads advice.rb

class App
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {"Content-Type" => "text/html"}, [erb(:index)]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {"Content-Type" => 'text/html'},
        [erb(:advice, message: peice_of_advice)]
      ]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '61'},
        [erb(:not_found)]
      ]
    end
  end

  private

  def erb(filename, local={})
    b = binding
    message = local[:message]
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)
  end
end

# config.ru
require_relative 'app'

run App.new
