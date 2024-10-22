class ScrapingsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    url = params[:url]
    
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    page = Nokogiri::HTML(response.body)
    
    # Abre a página com open-uri
    page = Nokogiri::HTML(URI.open(url))
    
    # Coletar o preço
    price = page.at_css('.VehicleDetailsFipe__price__value')&.text

    # Coletar a marca e o modelo
    brand = page.at_css('#VehicleBasicInformationTitle')&.text
    model = page.at_css('.VehicleDetails__header__title strong')&.text

    # Verificar se os dados foram encontrados
    if price.nil? || brand.nil? || model.nil?
      render json: { error: 'Could not retrieve data. Please check the selectors or the page structure.' }, status: :bad_request
    else
      # Retornar os dados em formato JSON
      render json: {
        price: price.strip,
        brand: brand.strip,
        model: model.strip
      }
    end

  rescue OpenURI::HTTPError => e
    render json: { error: "Could not retrieve data: #{e.message}" }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
