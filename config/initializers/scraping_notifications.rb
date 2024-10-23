ActiveSupport::Notifications.subscribe('scraping.created') do |name, start, finish, id, payload|
    scraping = payload[:scraping]
    task = payload[:task]

    Rails.logger.info "Notifying about scraping #{task.id}"

    notification_payload = {
        task_id: task.id,
        extracted_data: 
        {
            price: scraping.price,
            brand: scraping.brand,
            model: scraping.model
        }        
        #   task_url: task.url,
        #   task_status: task.status
        #   #user_id: user.id,
        #   #user_name: user.name,
        #   #user_email: user.email
    }

    response = Faraday.post(ENV['URL_NOTIFICATION'], notification_payload.to_json, "Content-Type" => "application/json")

    if response.success?
        Rails.logger.info "Notification sent to Notifications API successfully!"
    else
        Rails.logger.error "Error sending notification: #{response.body}"
    end
    #puts "Scraping record created with price: #{scraping.price}"
end
