# frozen_string_literal: true

require_relative 'particle'

module ParticleFX2D
  #
  # A particle effect emitter
  #
  class Emitter
    attr_accessor :emission_rate, :particle_config

    #
    # Create a new particle emitter
    #
    # @param opts Options to configure the emitter as follows:
    # - +quantity+ Number of total particles in the emitter's pool
    # - +emission_rate+ Number of particles to emit per second
    # - +particle_config+ Options are used to configure each particle when it is emitted, which are as follows:
    #   - +x+ Initial x-axis position of emission
    #   - +x_range+ optional range from which a random value is chosen to add to the initial +x+; default is 0
    #   - +y+ Initial y-axis position of emission
    #   - +y_range+ optional range from which a random value is chosen to add to the initial +y+; default is 0
    #   - +start_color+ optional initial colour of the emitted particle. See `Particle` for default
    #   - +end_color+ optional end colour of the particle by the end of its life. See `Particle` for default
    #   - +start_scale+ optional initial size scale factor of the emitted particle relative to its +size+; default is 1
    #   - +end_scale+ optional end size scale factor of the particle by the end of its life; default is 1
    #   - +angle+  optional angle at which the particle is emitted, in degrees. See `Particle` for default
    #   - +angle_range+ optional range from which a random value is chosen to add to the +angle+; default is 0
    #   - +speed+  optional speed at which the particle is emitted, in pixels/s. See `Particle` for default
    #   - +speed_range+ optional range from which a random value is chosen to add to the +speed+; default is 0
    #   - +size+  optional size of the particle when emitted, in pixels. See `Particle` for default
    #   - +size_range+ optional range from which a random value is chosen to add to the +size+; default is 0
    #   - +gravity_x+ optional linear acceleration in pixels/second squared along the x axis, default is 0
    #   - +gravity_y+ optional linear acceleration in pixels/second squared along the y axis, default is 0
    #   - +radial_acceleration+ optional radial accelation in pixel/seconds squared, default is 0
    #   - +tangential_acceleration+ optional tangential accelation in pixel/seconds squared, default is 0
    #   - +life_time+ of each particle in seconds. See `Particle` for default
    #   - +life_time_range+ optional range from which a random value is chosen to add to the +life_time+; default is 0
    #
    def initialize(opts = {})
      @quantity = (opts[:quantity] || 128).to_i
      @emission_rate = opts[:emission_rate].to_f
      @emission = 0
      @particle_config = opts[:particle_config]
      @renderer = opts[:renderer]
      setup_particle_pool
    end

    #
    # Update the particle effect emission, called for each frame of the animation cycle.
    #
    # @param [Float] frame_time in seconds (essentially, 1 / fps)
    #
    def update(frame_time)
      emit_particles frame_time
      @active.each do |p|
        p.update frame_time
        free_particle p unless p.alive?
      end
    end

    #
    # Retrieve statistics about the emitter's current status
    #
    # @return A hash with the following properties:
    # - +quantity+ The total number of particles in the emitter
    # - +emission_rate+ The emission rate (particles per second)
    # - +active+ The number of active particles
    # - +unused+ The number of inactive particles in the pool
    #
    def stats
      {
        quantity: @quantity,
        emission_rate: @emission_rate,
        active: @active.count,
        unused: @pool.count
      }
    end

    private

    # Initialize the particle pool; call once per emitter.
    def setup_particle_pool
      @active = []
      @pool = []
      @quantity.times do
        p = Particle.new
        s = @renderer.for(p)
        p.shape! s
        free_particle p
      end
    end

    # For each update frame emit as many particles as specified by the emission rate.
    # May emit less that the rate if there aren't enough particles in the pool
    def emit_particles(frame_time)
      return unless @emission_rate.positive?

      rate = @emission_rate * frame_time
      @emission += rate
      while @active.count < @quantity && @emission > rate
        new_particle
        @emission -= 1
      end
    end

    # Generate a value for a particle configuration range-based property.
    #
    # @return nil if no config with +prop_name+ is found
    def config_range_value(prop_name, prop_range_name)
      return nil unless @particle_config[prop_name.to_sym]

      prop_range = @particle_config[prop_range_name.to_sym]
      @particle_config[prop_name.to_sym] + (prop_range ? rand(prop_range) : 0)
    end

    # Retrieve a value for a particle configuration value-only property.
    #
    # @return nil if no config with +prop_name+ is found
    def config_value(prop_name, prop_alt_name = nil)
      @particle_config[prop_name.to_sym] || (@particle_config[prop_alt_name.to_sym] if prop_alt_name)
    end

    # Reset a particle based on the emitter's particle config.
    # This is done before emitting a particle from the particle pool
    def reset_particle(particle)
      particle.reset! x: config_range_value(:x, :x_range),
                      y: config_range_value(:y, :y_range),
                      color: config_value(:start_color, :start_colour),
                      end_color: config_value(:end_color, :end_colour),
                      scale: config_value(:start_scale), end_scale: config_value(:end_scale),
                      gravity_x: config_value(:gravity_x), gravity_y: config_value(:gravity_y),
                      radial_acceleration: config_range_value(:radial_acceleration, :radial_acceleration_range),
                      tangential_acceleration: config_range_value(:tangential_acceleration, :tangential_acceleration),
                      size: config_range_value(:size, :size_range),
                      speed: config_range_value(:speed, :speed_range),
                      angle: config_range_value(:angle, :angle_range),
                      life_time: config_range_value(:life_time, :life_time_range)
    end

    # Retrieve an unused particle from the pool, reset it,
    # and show it's associated shape/peer
    def new_particle
      p = @pool.pop
      return unless p

      @active << p
      reset_particle p
      p.shape&.show
    end

    # Return a particle back to the unused pool,
    # and hide it's associated shape/peer
    def free_particle(particle)
      ix = @active.find_index particle
      @active.delete_at ix unless ix.nil?
      @pool.push particle
      particle.shape&.hide
    end
  end
end
