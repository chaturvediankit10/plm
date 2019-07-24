namespace :price_alert do
 	task weekly_mail_price_alert: :environment do
 		 User.all.where(price_alert: 1).each do |user|
 		 	ContactUsMailer.weekly_price_alert_email(user).deliver
 		 end
 	end

 	task daily_mail_price_alert: :environment do
 		 User.all.where(price_alert: 0).each do |user|
 		 	ContactUsMailer.daily_price_alert_email(user).deliver
 		 end
 	end
end

