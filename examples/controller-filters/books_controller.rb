class BooksController < ApplicationController
  # Using a filter allows us to set the @authenticated
  # instance variable for every request and make sure
  # someone is signed in. It reduces the branching in
  # the actions and makes them overall shorter.
  before_action :find_authenticated

  # We've replaced the repeated Book.find from the actions
  # with a before filter. This allows us to keep the
  # contents of the actions shorter and more readable.
  before_action :find_book, only: %i(show edit update destroy)

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

  # We read the authenticated through a controller method and
  # in the views we read it through a helper method. This allows
  # us to override in subclasses or specific views.
  attr_reader :authenticated
  helper_method :authenticated

  # By wrapping the authentication token in a method we open
  # up to possibility for other ways to present this token.
  # For example through params, the session, or a header.
  def authentication_token
    cookies[:authentication_token]
  end

  # This is the only place where we now have the branch to
  # see if anyone is signed in.
  def find_authenticated
    if @session = Session.find_by(token: authentication_token)
      @authenticated = @session.target
    else
      head :unauthorized
    end
  end

  # We use Book.find so Rails throws and catches the RecordNotFound
  # error for us and takes care of a nice 404 page for non-existent
  # books.
  def find_book
    @book = Book.find(params[:id])
  end

  # We read the book params from an accessor so we only need to
  # change one method when a book record needs to accept more attributes.
  def book_params
    params.require(:book).permit(:title, :description)
  end
end