# Timesheets - SPA

Please access the application at time2.cs5610f19.website

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Generate the seed data using `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
## Instructions
  * Use `mix run priv/repo/seeds.exs` to get the seed data
  * Jobs and users are pre loaded, find the credentials below
  * Sheets are not pre loaded.
  
## Attributions and References
* In addition to https://github.com/hemanthnhs/CS5610-WebDev-HW6
* Reference https://daveceddia.com/how-does-redux-work/
* https://stackoverflow.com/questions/5805059/how-do-i-make-a-placeholder-for-a-select-box
## Design Decisions
* In addition to https://github.com/hemanthnhs/CS5610-WebDev-HW6

## Sample Data to login

Please use the following data to login and test the application
Managers
email: manager1@example.com  
password: passwordmanager1  
manages workers 1 to 5

email: manager2@example.com  
password: passwordmanager2  
manages workers 6,7

email: manager3@example.com  
password: passwordmanager3  
manages workers 8,9

Workers Format is as follows(number 1 to 9)
email: worker<number>@example.com
password: passwordworker<number>

For example worker 1
email: worker1@example.com  
password: passwordworker1

For example worker 3
email: worker3@example.com  
password: passwordworker3
