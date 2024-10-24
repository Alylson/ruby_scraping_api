ActiveSupport::Notifications.subscribe('scraping.created') do |name, start, finish, id, payload|
    scraping = payload[:scraping]
   
    #Rails.logger.info "Notification received: #{scraping.inspect}"

    if scraping.present?
        #Rails.logger.info "Notification test 2 #{scraping}"
    
        payload = {
            task_id: 1,
            notification_payload: {
                brand: scraping.brand,
                model: scraping.model,
                price: scraping.price
            }
        }
    
        response = Faraday.post(ENV['URL_NOTIFICATION'], payload.to_json, "Content-Type" => "application/json")
    else
        Rails.logger.error "Scraping object is nil!"
    end

    if response.success?
        Rails.logger.info "Notification sent to Notifications API successfully!"
    else
        Rails.logger.error "Error sending notification: #{response.body}"
    end
end
