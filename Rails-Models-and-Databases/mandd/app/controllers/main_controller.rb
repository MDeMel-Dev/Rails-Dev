class MainController < ApplicationController

    def home
        render inline: "<center><h1> Kiddster API </h1></center>"
    end

    def index
        @jokes = Joke.all
        render json: @jokes
    end

    def show
        render json: Joke.find(params[:id])
    end

    def types
        @jktypes = Joke.select(:jktype)
        render json: @jktypes.map { |jkt| jkt[:jktype] }.uniq 
    end

    def showtype
        @jkts = Joke.where(jktype: params[:jkt])
        render json: @jkts
    end
    
end