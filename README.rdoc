# Reservations Screening Problem Application

## Setup

1. Clone the repo as usual.
1. Install the Ruby version. I've used RVM and Ruby 2.2.2, which is specified in the .ruby-version file. If you're using RVM, run:
   `rvm install ruby-2.2.2`
1. Run `bundle install` as usual to install gems.
1. Run `rake db:migrate` as usual to create the database.
1. Run `rake db:seed` to populate the `tables` in the database, containing about the restaurants tables. (Modify `db/seeds.rb` as needed to match the table configuration in your hypothetical restaurant.)
1. Run the test suite with `rake test` as usual.
1. Start up the app and server as usual with `rake server`.
1. http://localhost:3000

## Other Notes

The code for this app might be overkill for a screening/coding exercise, but I'm just using a base app template that I've used on multiple projects now. Some notes on this base app and corresponding approach:

* I use the https://github.com/polypressure/outbacker gem (which I've been using privately for a while now and just recently published it as a gem) to keep business logic out of controllers and models, to support isolated testing, etc. There's a single business-logic object in this app: app/domain/reservation_book.rb.
* I push validation (as well as input parsing/normalization logic) into form objects, again to keep models lean and focused on persistence. There's a single form object in this app: app/forms/reservation_form.rb.
* I use Zurb Foundation out of the box to style the app minimally, which I find gets things looking respectable and not so Bootstrappy, with less effort than Bootstrap.
* I use Slim for templating.
* For testing:
  * I use Minitest rather than RSpec, which I find encourages simple, flat tests with less magic.
  * I'm back to using plain old fixtures whenever I can—certainly for this simple app they're adequate.
  * I use Mocha, mostly for stubbing to support isolated tests, and I try to avoid any mocking so that tests are less brittle. Too often, mocking is done in such away that tests have cascading errors due to brittle mock objects, with a bunch of noise obscuring what exactly needs to be fixed. However, while I tend to avoid mocks, I don't strictly follow a classicist testing style—my style is probably somewhere in between the classicist and mockist styles of testing.
  * I use Page Objects for feature/acceptance tests, with the SitePrism gem (https://github.com/natritmeyer/site_prism).
  * In general, I don't worry about duplication in tests, see ￼￼"Working Effectively with Unit Tests" by Jay Fields.

See app/models/table.rb for a few more notes on the database schema.
