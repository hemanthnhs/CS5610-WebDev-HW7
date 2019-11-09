# Timesheets2 - SPA

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
* Major attribution, reference and code is from Nats Notes : https://github.com/NatTuck/lens/tree/spa4-user-sessions (SPA's, session's, ajax, store)
* Lens example https://github.com/NatTuck/lens/blob/spa4-user-sessions
* Reference https://daveceddia.com/how-does-redux-work/
* https://stackoverflow.com/questions/5805059/how-do-i-make-a-placeholder-for-a-select-box
* https://stackoverflow.com/questions/8215556/how-to-check-if-input-date-is-equal-to-todays-date
* https://stackoverflow.com/questions/52030110/sorting-strings-in-descending-order-in-javascript-most-efficiently
* https://stackoverflow.com/questions/35341696/how-to-convert-map-keys-to-array
* https://hexdocs.pm/phoenix/Phoenix.Socket.html#c:id/1
* https://elixirforum.com/t/map-filter-and-reduce/1219
* https://chadly.github.io/react-bs-notifier/
* https://stackoverflow.com/questions/7000851/array-sort-doesnt-sort-numbers-correctly
* Stackoverflow discussions related to map and return
* Redirect ReactDOM docs
* Channel subscription https://piazza.com/class/k03dspgc6oo42p?cid=248
* React Bootstrap docs

## Design Decisions
* In addition to https://github.com/hemanthnhs/CS5610-WebDev-HW6
* For manager and worker you can come back to dashboard/home any time by clicking on 'TimeSheets-Home' in the navigation.
* The manager has options to see the time sheets in dashboard/home.
* Manager can approve from the dashboard directly or view it and approve in the show/view page.
* Worker has options to fill new sheet from navigation or can see their submitted sheets in homepage/dashboard.
* When worker navigates to some other page and comes back to fill new sheet the sheet will be cleared and needs to be filled again (Design decision)
* Validations related to submissions are done both in frontend and backend.
* Partial tasks (rows with only jobid or hours but not both) will not be saved and atleast one valid/filled task row should be entered to submit.
* Total hours must be less than or equal to 8 to submit a timesheet
* Only completed/filled tasks(i.e with jobcode and hours) are saved
* Blank rows are allowed and handled.
* Alert to manager when a user submits timesheet less than 8 hours will be timedout in 15s or on dismiss.
* The requests will be seen by manager immediately and approved status will reflect immediately for the worker

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
