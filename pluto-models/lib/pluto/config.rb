# frozen_string_literal: true

module Pluto
  class Configuration
    attr_writer :debug

    def debug? = @debug || false

    def logger
      ## always return root for now; let's you globally configure e.g.
      ##     logger.level = :debug etc.
      LogUtils::Logger.root
    end
  end

  ## lets you use
  ##   Pluto.configure do |config|
  ##      config.debug        = true
  ##      config.logger.level = :debug
  ##   end

  def self.configure
    yield(config)
  end

  def self.config
    @config ||= Configuration.new
  end
end
