class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy toggle_availability ]

  def show
  end

  def new
    @product = Product.new(category_id: params[:category_id])
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_availability
    availability_params = params.expect(product: [:is_available])
    @product.update(availability_params)
  end

  def destroy
    @product.destroy!

    redirect_to @product.category, status: :see_other, notice: "Product was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [:title, :price, :discount_price, :image, :category_id])
    end
end
