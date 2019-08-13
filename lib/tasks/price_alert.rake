namespace :price_alert do

	task daily_mail_price_alert: :environment do
 		 User.all.where(price_alert: 0).each do |user|
 		 	ContactUsMailer.daily_price_alert_email(user).deliver
 		 end
 	end

 	task weekly_mail_price_alert: :environment do
 		 User.all.where(price_alert: 1).each do |user|
 		 	ContactUsMailer.weekly_price_alert_email(user).deliver
 		 end
 	end

 	task monthly_mail_price_alert: :environment do
 		 User.all.where(price_alert: 2).each do |user|
 		 	ContactUsMailer.monthly_price_alert_email(user).deliver
 		 end
 	end
end

