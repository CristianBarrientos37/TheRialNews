class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  before_action only: [:new, :create] do
    authorize_request(["author", "admin"])
  end

  before_action only: [:edit, :update, :destroy] do
    authorize_request(["admin"])
  end
  
  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @post = Post.find(params[:post_id])  # Obtén el post relacionado
    @comment = Comment.find(params[:id])  # Obtén el comentario
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :ok, location: @comment}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @post = Post.find(params[:post_id])  # Obtén el post relacionado
    @comment = Comment.find(params[:id])
  
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Comentario actualizado con éxito.'
    else
      render :edit
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    if current_user.admin?
      @comment.destroy!
      respond_to do |format|
        format.html { redirect_to comments_path, status: :see_other, notice: "Comentario borrado con exito" }
        format.json { head :no_content }
      end
    else
      redirect_to comments_path, alert: "No tienes permiso para eliminar este comentario."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end
end
