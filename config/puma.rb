# frozen_string_literal: true

threads 5, 5
port ENV.fetch("PORT", 3000)
environment ENV.fetch("RACK_ENV", "development")
