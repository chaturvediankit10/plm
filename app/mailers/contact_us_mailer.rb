class ContactUsMailer < ApplicationMailer
 #Mailer for sending user's query to admin
  default from: "from@example.com"
  def contact_us_email(admin_user,query)
    @query= query
    mail(to: admin_user, subject: "Query From "+query[:name])
  end

  def weekly_price_alert_email(user)
  	@favorites = user.user_favorites
  	mail(to: user.email, subject: "Weekly Price Alert")
  end

  def daily_price_alert_email(user)
  	@favorites = user.user_favorites
  	mail(to: user.email, subject: "Daily Price Alert")
  end
  
end
