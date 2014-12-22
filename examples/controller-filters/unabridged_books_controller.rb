class UnabridgedBooksController < ApplicationController
  def new
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target
      @book = Book.new
    else
      head :unauthorized
    end
  end

  def create
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target

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
    else
      head :unauthorized
    end
  end

  def show
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target

      # We repeat the find on the book for the show, edit,
      # update, and destroy action. This seems like a
      # pattern.
      @book = Boom.find(params[:id])
    else
      head :unauthorized
    end
  end

  def edit
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target
      @book = Boom.find(params[:id])
    else
      head :unauthorized
    end
  end

  def update
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target

      @book = Boom.find(params[:id])
      @book.attributes = params.require(:book).permit(
        :title, :description
      )
      if @book.save
        redirect_to @book
      else
        render :edit
      end
    else
      head :unauthorized
    end
  end

  def destroy
    if @session = Session.find_by(token: cookies[:authentication_token])
      @authenticated = @session.target

      @book = Book.find(params[:id])
      @book.destroy
      redirect_to books_url
    else
      head :unauthorized
    end
  end
end