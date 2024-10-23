class ScrapingsController < ApplicationController
  require 'puppeteer-ruby'

  def index
    url = params[:url]
    task_id = params[:task_id]

    Puppeteer.launch(headless: true, args: ['--no-sandbox']) do |browser|
      page = browser.new_page
      page.goto(url)

      price = '299.00'
      brand = 'BMW'
      model = 'X1'

      if price.nil?
        render json: { error: 'Could not retrieve data. Please check the selectors or the page structure.' }, status: :bad_request
      else
        scraping_record = Scraping.new(price: price.strip, brand: brand.strip, model: model.strip)

        if scraping_record.save
          ActiveSupport::Notifications.instrument('scraping.created', task_id: task_id, scraping: scraping_record)

          render json: {
            price: scraping_record.price,
            brand: scraping_record.brand,
            model: scraping_record.model
          }
        else
          render json: { error: 'Could not save data to the database.' }, status: :internal_server_error
        end
      end
    end

  rescue Puppeteer::TimeoutError => e
    render json: { error: "Could not retrieve data: #{e.message}" }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
