ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"

require "minitest/pride"

require "minitest/reporters"
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

require 'outbacker'
require 'test_support/outbacker_stub'

RAILS_ROOT = File.expand_path('../..', __FILE__)
Dir[File.join(RAILS_ROOT, 'test/support/**/*.rb')].each {|f| require f}


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_reservation(datetime, party_size, customer, table)
    Reservation.create!(datetime: datetime,
                        party_size: party_size,
                        customer: customer,
                        table: table)
  end
end

class ActionController::TestCase
  #
  # Disable view rendering in controller tests, as making assertions
  # against HTML content in views really makes them integration tests.
  # This also speeds up controller tests.
  #
  setup do
    ActionView::Template.class_eval{ alias_method :render, :stubbed_render }
  end
  teardown do
    ActionView::Template.class_eval{ alias_method :render, :unstubbed_render }
  end

  #
  # Helper method to assert a flash message of the specified
  # type (e.g. :notice, :alert, etc.) matches the given regex.
  #
  def assert_flash(type:, message:)
    assert_match /#{message}/, flash[type]
  end
end

class ActionView::Template
  alias_method :unstubbed_render, :render
  def stubbed_render(*)
    ActiveSupport::Notifications.instrument("!render_template.action_view",
                                            :virtual_path => @virtual_path) do
      # nothing but the instrumentation
    end
  end
end

#
# Randomly set an American timezone to help expose timezone-related bugs:
#
_us_time_zones = ActiveSupport::TimeZone.us_zones.map(&:name)
Time.zone = _us_time_zones[rand(_us_time_zones.length)]
puts "[Setting random US timezone: #{Time.zone}]"

require 'site_prism'
require 'mocha/mini_test'
