class CryptosController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: %i[ show edit update destroy ]
  before_action :set_crypto, only: %i[ show edit update destroy ]
  before_action :created_by_current_user?, only: %i[ create ]
  before_action :redirect_if_invalid_symbol, only: %i[ create ]

  # GET /cryptos or /cryptos.json
  def index
    @cryptos = current_user.cryptos
    @crypto_listings = helpers.crypto_listings_api_call
    @total_profit_loss = 0
  end

  # GET /cryptos/1 or /cryptos/1.json
  def show
    @crypto_name = params[:crypto_name]
  end

  # GET /cryptos/new
  def new
    @crypto = Crypto.new
  end

  # GET /cryptos/1/edit
  def edit
    @crypto_name = params[:crypto_name]
  end

  # POST /cryptos or /cryptos.json
  def create
    @crypto = Crypto.new(crypto_params)

    respond_to do |format|
      if @crypto.save
        format.html { redirect_to @crypto, notice: "Crypto was successfully created." }
        format.json { render :show, status: :created, location: @crypto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cryptos/1 or /cryptos/1.json
  def update
    respond_to do |format|
      if @crypto.update(crypto_params)
        format.html { redirect_to @crypto, notice: "Crypto was successfully updated." }
        format.json { render :show, status: :ok, location: @crypto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cryptos/1 or /cryptos/1.json
  def destroy
    @crypto.destroy
    respond_to do |format|
      format.html { redirect_to cryptos_url, notice: "Crypto was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crypto
      @crypto = Crypto.find(params[:id])
    end

    # Prevent user from accessing resources that don't belong to them
    def correct_user?
      unless current_user.cryptos.find_by(id: params[:id])
        redirect_to cryptos_path, notice: "Not authorized."
      end
    end

    # Prevent user from creating resources for other users
    def created_by_current_user?
      unless params[:crypto][:user_id].to_i == current_user.id
        redirect_to cryptos_path, notice: "Not authorized."
        return
      end
    end

    # Only allow a list of trusted parameters through.
    def crypto_params
      params.require(:crypto).permit(:symbol, :user_id, :cost_per, :amount_owned)
    end

    def redirect_if_invalid_symbol
      @crypto_listings = helpers.crypto_listings_api_call
      @crypto_listings.each do |listing|
        if listing['symbol'] == params[:crypto][:symbol].upcase
          return
        end
      end
      
      redirect_to cryptos_path, notice: "Unable to add #{params[:crypto][:symbol]}."
      return
    end

end
