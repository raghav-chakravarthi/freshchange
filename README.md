# Freshchange

A Ruby on Rails application developed for the Freshworks University Bootcamp. This application can track the competitors websites every hour (depending on the load) and notify the registered user if the website changes.

## Working

There can be multiple accounts and each accounts can further have more users associated with them. Each user can add the websites they want to track. The account owner has complete control over all the associated users. Once the website is added by the user, screenshots of the initial webpage is saved. When the scheduled cron job is being triggered, it compares the previous screenshot with the new screenshot and compares it pixel by pixel. If the website was updated, a mailer notifies the associated user by highliting the portion where the website was changed.

## Requirements

* A Laptop with Ubuntu / Linux / iOS (as cron jobs only work on Linux / iOS) with Internet connection
* Install Ruby 2.6.0
* Install Rails 5.2.0

## Working


As of now, this application is open-source and anyone can use this by cloning the repository.
Once all the requirements are satisfied, go to the project location and run the following commands in the terminal.

First make sure that Ruby and Rails are installed properly by running

```
ruby -v
rails -v
```

Once Ruby and Rails are installed properly in your laptop, run the following commands to setup the app

Run
```
bundle install
```
to install the gems that are required

After that, run the following commands

```
rails db:create
rails db:migrate
rails db:seed
```

Now, to make the cron job to run every minute, run the following commands.

```
whenever
whenever --update-crontab
sudo service cron restart
crontab
```
You can change to duration of the cron tasks in the schedule.rb file and run the cron again by running the commands given above.

With everything set, it's time to start the server. The server can be started using the command

```
rails s
``` 

in the terminal. Once the server is running, go the browser and hit the url "localhost:3000". This would load the web page and you are good to go!


## Application walkthrough


### Log in
![Log in](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/1.png "Log in")



### Dashboard
![Log in](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/2.png "Dashboard")



### User details
![User](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/3.png "User details")



### Two week report
![Report](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/4.png "Two week report")



### First, latest change and internal marketing tools
![Tools](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/5.png "Tools")



### Triggered mail
![Mail](https://github.com/raghav-chakravarthi/freshchange/blob/master/public/assets/6.png "Mail")

