class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
 
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
   

    if @book.save
      flash[:notice] = "successfully"
      redirect_to book_path(@book)
    else
      @user = User.find(current_user.id)
      @books = Book.all
      render :index
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new = Book.new
    @books = @user.books
   
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
    # @book = Book.new
   
  end

  def update
    is_matching_login_user
    @book =Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "successfully"
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @book =Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end


end
