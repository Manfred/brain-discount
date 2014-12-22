class SillyBooksController < ApplicationController
  before_filter :initialize_book, only: %i(new create)
  before_filter :find_book, only: %i(show edit update destroy)
  before_filter :destroy_book, only: %i(destroy)

  def create
    save_and_redirect_or_render :new
  end

  def update
    @book.attributes = book_params
    save_and_redirect_or_render :edit
  end

  def destroy
    redirect_to books_url
  end

  private

  def initialize_book
    @book = Book.new(book_params)
  end

  def find_book
    @book = Book.find(params[:id])
  end

  def destroy_book
    @book.destroy
  end

  def book_params
    params.require(:book).permit(:title, :description)
  end

  def save_and_redirect_or_render(template_name)
    if @book.save
      redirect_to @book
    else
      render template_name
    end
  end
end