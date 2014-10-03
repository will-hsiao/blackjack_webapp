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

    def lose!(msg)
        @error = msg
        @player_button_on = false
        @play_again_button_on = true
    end

    def win!(msg)
      @success = msg
      @player_button_on = false
      @play_again_button_on = true
    end

    def tie!(msg)
      @success = msg
      @player_button_on = false
      @play_again_button_on = true
    end

end

before do
    @player_button_on = true
    @host_button_on = false
    @host_first_card_on = false
end

get '/' do
    if session[:player_name]
        redirect '/game'
    else
        erb :new_player
    end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:username] == ""
    @error = "You must input your name."
    halt (erb :new_player)
  end
  session[:player_name]=params[:username]
  redirect '/game'
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
    session[:player_card] << session[:deck].pop
    player_sum = calculate (session[:player_card])
    if player_sum > 21
        lose!("#{session[:player_name]} busted at #{player_sum}!")
    elsif player_sum == 21
        win!("#{session[:player_name]} hit Blackjack!")
    end
    erb :game
end

post '/stay' do
    redirect '/host'
end

get '/host' do
    player_button_on = false
    host_sum = calculate (session[:host_card])

    if host_sum > 21
        #@success = "Host busted, you win! " 
        win!("Host busted at #{host_sum}, #{session[:player_name]} win! " )
    elsif host_sum == 21
        lose!("Host hits BlackJack! #{session[:player_name]} lose!" )
    elsif host_sum < 17
        @host_button_on = true
    elsif host_sum >=17
        @host_button_on = false
        redirect '/game/compare'
    end
    @host_first_card_on = true
    erb :game
end

post '/host_hit' do
    session[:host_card] << session[:deck].pop
    redirect '/host'
end

post '/game' do
  session[:player_name] = params['username']
  redirect '/game'
end

get '/game/compare' do
    #Compare Player and Host
    host_sum = calculate (session[:host_card])
    player_sum = calculate (session[:player_card])
    if host_sum > player_sum
        lose!("Host Win at #{host_sum}! #{session[:player_name]} lose at #{player_sum}!")
    elsif host_sum == player_sum
        tie!("It's a tie at #{player_sum} !")
    else
        win!("#{session[:player_name]} win at #{player_sum}!")
    end
    @host_first_card_on = true
    erb :game
end


