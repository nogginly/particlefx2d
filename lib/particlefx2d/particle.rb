# frozen_string_literal: true

require_relative 'private/vector2'
require_relative 'private/color'

module ParticleFX2D
  #
  # A single 2D particle.
  #
  class Particle
    attr_reader :x, :y, :color, :end_color, :velocity, :speed, :angle, :life, :size, :shape,
                :gravity_x, :gravity_y, :radial_accel, :tangent_accel, :scale, :end_scale

    # @!visibility private
    # Create a new particle
    #
    # @param opts Options describing the particle. See #reset! for alll the properties.
    #
    def initialize(opts = {})
      reset!(opts)
    end

    #
    # Used by the _Emitter_ when re-using particles from the particle pool.
    #
    # @param opts Options describing the particle as follows:
    # - +x+ defaults to 0
    # - +y+ defaults to 0
    # - +color+ or +colour+ array of particle's color components [r, g, b, a]; default is _[0, 1.0, 0, 1.0]_ (green)
    # - +end_color+ or +end_colour+ array of particle's end color [r, g, b, a]; default is _[1.0, 0, 0, 1.0]_ (red)
    # - +angle+ in degrees; default is 0
    # - +speed+ in pixels per second; default is 100
    # - +life_time+ in seconds; default is 100.0
    # - +size+ in pixels; default is 5
    # - +scale+ relative to size, default is 1
    # - +end_scale+ particle's end scale relative to size; default is +scale+
    # - +gravity_x+ in pixels/second squared along the x axis, default is 0
    # - +gravity_y+ in pixels/second squared along the y axis, default is 0
    # - +radial_acceleration+ in pixel/seconds squared, default is 0
    # - +tangential_acceleration+ in pixel/seconds squared, default is 0
    #
    def reset!(opts = {})
      @initial_life = @life = value_from(opts, :life_time, default: 100).to_f
      @initial_size = @size = value_from(opts, :size, default: 5)
      @gravity = Private::Vector2.new value_from(opts, :gravity_x, default: 0),
                                      value_from(opts, :gravity_y, default: 0)
      # following may depend on initial life and size
      reset_forces opts
      reset_scale_from opts
      reset_position_from opts
      reset_color_from opts
      reset_velocity_from opts
    end

    #
    # Set the rendering shape/peer for the particle.
    #
    # @param shape The renderer, must implement following methods:
    # - +show+ Make the particle visible
    # - +hide+ Make the particle invisible
    # - +sync!(particle)+ Update the display properties based on the particle's properties
    #
    def shape!(shape)
      @shape = shape
    end

    #
    # Returns true if the particle is considered alive
    #
    def alive?
      @life.positive?
    end

    #
    # Used by the _Emitter_ to update the particle by +frame_time+ seconds.
    #
    # @param [Float] frame_time in seconds
    #
    def update(frame_time)
      @life -= frame_time
      return unless alive?

      @scale += @delta_scale * frame_time
      @size = @initial_size * @scale
      @color.add!(@delta_color, each_times: frame_time)
      update_forces
      update_motion frame_time
      @shape&.sync! self
    end

    private

    # Calculates the number of pixels the particle should move
    # based on its velocity and force of acceleration. Called per axis.
    def accelerated_velocity(velocity, force_per_frame)
      velocity + (force_per_frame.abs2 / 2)
    end

    # Update the force of acceleration based on configured gravity, radial accel and
    # tangential accel if applicable.
    def update_forces
      @forces.copy! @gravity
      return @forces if (@radial_accel.zero? && @tangent_accel.zero?) || (@x == @initial_x && @y == @initial_y)

      @radial.set!(@x, @y)
             .subtract!(@initial_x, @initial_y)
             .normalize!
      @tangential.copy!(@radial)
                 .cross!
                 .times!(@tangent_accel)
      @forces.add_vector!(@radial.times!(@radial_accel))
             .add_vector!(@tangential)
    end

    # Update the motion for a frame of animation based on the updated forces and velocity
    def update_motion(frame_time)
      @forces.times!(frame_time)
      @x += accelerated_velocity @velocity.x * frame_time, @forces.x
      @y += accelerated_velocity @velocity.y * frame_time, @forces.y
      @velocity.add_vector! @forces
    end

    # Initialize position from configuration options
    def reset_position_from(opts)
      @initial_x = @x = value_from(opts, :x, default: 0)
      @initial_y = @y = value_from(opts, :y, default: 0)
    end

    # Initialize scale factors from configuration options
    def reset_scale_from(opts)
      @initial_scale = @scale = value_from(opts, :scale, default: 1).to_f
      @end_scale = value_from(opts, :end_scale, default: @initial_scale).to_f
      @delta_scale = (@end_scale - @initial_scale) / @initial_life
    end

    # Initialize colours from configuration options
    def reset_color_from(opts)
      @initial_color = value_from(opts, :color, alt_name: :colour) || Private::Color.new([0, 1.0, 0, 1.0])
      @end_color = value_from(opts, :end_color, alt_name: :end_colour, default: @initial_color)
      @color = Private::Color.new(@initial_color)
      @delta_color = Private::Color.new(@end_color).subtract!(@initial_color).divide_by!(@initial_life)
    end

    # Convenient method to extract value for a particle configuration property
    # if present.
    def value_from(opts, name, default: nil, alt_name: nil)
      value = opts[name.to_sym]
      value ||= opts[alt_name.to_sym] unless alt_name.nil?
      value ||= default
      value
    end

    # Initialize velocity from configuration options
    def reset_velocity_from(opts)
      @angle = value_from(opts, :angle, default: 0).to_f
      @angle_in_radians = nil
      @speed = value_from(opts, :speed, default: 100).to_f
      @velocity ||= Private::Vector2.new
      angle_rad = @angle * Math::PI / 180
      @velocity.set! @speed * Math.cos(angle_rad),
                     -@speed * Math.sin(angle_rad)
    end

    # Initialize forces from configuration options
    def reset_forces(opts)
      @radial ||= Private::Vector2.new
      @tangential ||= Private::Vector2.new
      @forces ||= Private::Vector2.new
      @radial_accel = value_from(opts, :radial_acceleration, default: 0)
      @tangent_accel = value_from(opts, :tangential_acceleration, default: 0)
    end
  end
end
