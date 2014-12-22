class UnabridgedBooksController < ApplicationController
  def new
    @book = Book.new
  end

  def create
    # We repeat the params permit line for the create and
    # update actions. This seems like a pattern.
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
    # We repeat the find on the book for the show, edit,
    # update, and destroy action. This seems like a
    # pattern.
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

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url
  end
end