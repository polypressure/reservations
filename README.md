# Coding Exercise: Restaurant Reservations Application

## Setup

1. Clone the repo as usual: `git clone https://github.com/polypressure/reservations.git`
1. Install the Ruby version, Ruby 2.2.2, which is specified in the .ruby-version file. I'm using RVM, so:
   `rvm install ruby-2.2.2`
1. Run `bundle install` as usual to install gems.
1. Run `rake db:migrate` as usual to create the database.
1. Run `rake db:seed` to populate the (awkwardly-named) `tables` table in the database, which contains information about the restaurant's tables. You can first modify `db/seeds.rb` as needed to match the table configuration in your restaurant. Out of the box, it creates the following tables in the restaurant:
  * 3 tables that can seat 2 people.
  * 5 tables that can seat 4 people.
  * 3 tables that can seat 6 people.
  * 2 tables that can seat 8 people.
1. Run `rake db:test:prepare`, then run the test suite with `rake test` as usual.
1. Start up the app and server as usual with `rake server`.
1. [http://localhost:3000](http://localhost:3000)
1. It should look something like this: <img src=http://i.imgur.com/fh5yymJ.png>

## Other Notes

The code for this app might be overkill for a screening/coding exercise, but I'm just using a base app template that I've used on multiple projects now. Here are some notes on this base app and the corresponding approach:

* I keep business logic out of controllers and models, moving it to plain-old Ruby objects with the help of https://github.com/polypressure/outbacker. This is a microlibrary that I've been using privately for a while now, and which I just recently published as a gem. There's a single business-logic/domain object in this app: [app/domain/reservation_book.rb](https://github.com/polypressure/reservations/blob/master/app/domain/reservation_book.rb).
* I push validation (as well as input parsing/normalization logic) into form objects, again to keep models and their tests lean and focused on persistence. There's a single form object in this app: [app/forms/reservation_form.rb](https://github.com/polypressure/reservations/blob/master/app/forms/reservation_form.rb).
* I use [Zurb Foundation](http://foundation.zurb.com/) for the HTML/CSS framework, which I find gets things looking respectable and not so Bootstrappy—yet with less effort than Bootstrap.
* I use [Slim](http://slim-lang.com/) for templating rather than ERB or HAML.
* For testing:
  * I use [Minitest](http://docs.seattlerb.org/minitest/) rather than RSpec, which I find encourages simple, flat tests with less magic.
  * I'm back to using plain old fixtures whenever I can—certainly for this simple app they're adequate.
  * I use Mocha, mostly for stubbing to support isolated tests, and I try to avoid any mocking so that tests are less brittle. Too often, mocking is done in such away that tests have cascading errors due to brittle mock objects, with a bunch of noise obscuring what exactly needs to be fixed. However, while I tend to avoid mocks, I don't strictly follow a classicist testing style—my style is probably somewhere in between the classicist and mockist styles of testing.
  * I use Page Objects for feature/acceptance tests, with the [SitePrism gem](https://github.com/natritmeyer/site_prism).
  * In general, I don't worry about duplication in tests, see ￼￼"Working Effectively with Unit Tests" by Jay Fields.

See [app/models/table.rb](https://github.com/polypressure/reservations/blob/master/app/models/table.rb) for a few more notes on the database schema.
