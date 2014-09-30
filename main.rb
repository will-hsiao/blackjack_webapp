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
    if session[:player_name]
      redirect '/game'
    else
        erb :new_player
    end
end


get '/game' do

  #Set new cards  
    card_suite=["spade", "heart", "diamond", "club"]  
    card_rank=["ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "queen", "king", "jack"]  
#Shuffle Cards  
    session[:deck] = card_suite.product(card_rank)  
    session[:deck].shuffle!
    session[:player_card]=[]
    session[:host_card]=[]

 #Dispatch Cards 

   session[:player_card] << session[:deck].pop 
   session[:host_card] << session[:deck].pop
   session[:player_card] << session[:deck].pop 
   session[:host_card] << session[:deck].pop

   erb :game
end

post '/hit' do
    erb :hit
end

post '/stay' do
    erb :stay
end

post '/game' do
  session[:player_name] = params['username']
  redirect '/game'
end



