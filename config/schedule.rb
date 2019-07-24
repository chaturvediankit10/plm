set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


# It would run 1:00 AM every Saturday.
every 0 1 * * 6 do
	rake "calculator_csv:import_calculator_csv"
end

# It would run 8:00 AM every Monday.
every :monday, at: "08:00 am" do
	rake 'price_alert:weekly_mail_price_alert'
end

# It would run 8:00 AM every Day.
every 1.day, at: '08:00 am' do
  rake 'price_alert:daily_mail_price_alert'
end