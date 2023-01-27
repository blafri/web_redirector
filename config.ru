# frozen_string_literal: true

require_relative "application"

use Rack::Logger
run Application.new
freeze_app
