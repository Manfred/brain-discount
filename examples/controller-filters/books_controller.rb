class BooksController < ApplicationController
  # We've replaced the repeated Book.find from the actions
  # with a before filter. This allows us to keep the
  # contents of the actions shorter and more readable.
  before_filter :find_book, only: %i(show edit update destroy)

  def new
    @book = Book.new
  end

  def create
    # We've replaced the explict permit of the book params
    # with an accessor method on the controller.
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book
    else
      render :new
    end
  end

  def update
    if @book.update_attributes(book_params)
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :description)
  end
end