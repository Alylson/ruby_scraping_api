class ScrapingsController < ApplicationController
  #require 'puppeteer-ruby'

  before_action :set_scrapings_params, only: %i[show update destroy]

  def index
    @scrapings = Scraping.all

    render json: { scrapings: @scrapings }, status: :ok
  end

  def create
    # url = params[:url]
    # task_id = params[:task_id]

    scraping_record = Scraping.new(scraping_params)
    
    scraping_record.price = "299.00"
    scraping_record.brand = "BMW"
    scraping_record.model = "X1"

    if scraping_record.save

      ActiveSupport::Notifications.instrument('scraping.created', scrapings: scraping_record)

      render json: { message: 'Scraping created successfully', scraping: scraping_record }, status: :created
    else
      render json: { error: 'Could not save data to the database.' }, status: :internal_server_error
    end
    # Puppeteer.launch(headless: true, args: ['--no-sandbox']) do |browser|
    #   page = browser.new_page
    #   page.goto(url)

    #   page.wait_for_function("() => document.querySelector('.VehicleDetailsFipe__price.VehicleDetailsFipe__price--announced') !== null")
    #   price = page.eval_on_selector('.VehicleDetailsFipe__price__value', 'el => el.textContent')
    #   brand = page.eval_on_selector('#VehicleBasicInformationTitle', 'el => el.textContent')
    #   model = page.eval_on_selector('.VehicleDetails__header__title strong', 'el => el.textContent')

    #   if price.nil? || brand.nil? || model.nil?
    #     render json: { error: 'Could not retrieve data. Please check the selectors or the page structure.' }, status: :bad_request
    #   else
    #     scraping_record = Scraping.new(price: price.strip, brand: brand.strip, model: model.strip)

    #     if scraping_record.save

    #       Rails.logger.info "Attempting to notify scraping.created with task_id: #{task_id} and scraping_record: #{scraping_record.inspect}"
    #       ActiveSupport::Notifications.instrument('scraping.created', scraping: scraping_record)

    #       render json: {
    #         price: scraping_record.price,
    #         brand: scraping_record.brand,
    #         model: scraping_record.model
    #       }
    #     else
    #       render json: { error: 'Could not save data to the database.' }, status: :internal_server_error
    #     end
    #   end
    # end

  # rescue Puppeteer::TimeoutError => e
  #   render json: { error: "Could not retrieve data: #{e.message}" }, status: :bad_request
  # rescue StandardError => e
  #   render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: @scraping, status: :ok
  end

  def update
    if @scraping.update(scrapings_params)
      render json: { message: 'Scraping Updated Successfully', scraping: @scraping }, status: :ok
    else
      render json: { errors: @scraping.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @scraping.destroy
      render json: { message: 'Scraping Deleted Successfully' }, status: :ok
    else
      render json: { errors: @scraping.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_scraping_params
    @scraping = Scraping.find(params[:id])
  end

  def scraping_params
    params.permit(:brand, :model, :price)
  end  
end
