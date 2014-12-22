class UnabridgedBooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params.require(:book).permit(
      :title, :description
    ))
    if @book.save
      redirect_to @book
    else
      render :new
    end
  end

  def show
    @book = Boom.find(params[:id])
  end

  def edit
    @book = Boom.find(params[:id])
  end

  def update
    @book = Boom.find(params[:id])
    @book.attributes = params.require(:book).permit(
      :title, :description
    )
    if @book.save
      redirect_to @book
    else
      render :edit
    end
  end
end