class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to quotes_path
    else
      render :new
    end
  end

  private

  def quote_params
    params.require(:quote).permit(:body, :author, :year, :verified)
  end

end
