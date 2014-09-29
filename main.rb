require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

helpers do
  def calculate(card)
      sum=0
      card.each do |c|
      if c[1].to_i>1 && c[1].to_i<11
          sum+= c[1]
      elsif c[1] =="queen" 
          sum+=10
      elsif c[1] == "king"
          sum+=10
      elsif c[1] ==  "jack"
          sum+=10
      elsif c[1] == "ace"
          sum+=10
      end
    end
  aces=card.select{|c| c[1]=="ace"}
  aces.count.times {sum-=9 if sum > 21}

  return sum  
 end

    def display_cards(c)
            "<img src=\"/images/cards/"+c[0].to_s+'s_'+c[1].to_s+'.jpg' +"\" />"
    end

end

get '/' do
    #if session[:player_name]
        #redirect '/game'
    #else
        erb :new_player
    #end
end


post '/game' do
    erb :game
end

post '/hit' do
    erb :hit
end

post '/stay' do
    erb :stay
end



