# frozen_string_literal: true

require_relative '../renderer_factory'

module ParticleFX2D
  module Ruby2D
    # The base definition for a Ruby2D shape-based renderer that can be peered to
    # a particle managed by the ParticleFX2D _Emitter_. Include this when defining
    # Ruby2D shape-specific classes to provide the Emitter to render
    # the particle.
    #
    # This approach requires a shape per particle.
    module ShapeRenderer
      include ParticleFX2D::Renderer

      # Show the particle. Used when a particle is activated.
      def show_particle(_particle)
        add
      end

      # Hide the particle. Used when a particle is deactivated.
      def hide_particle(_particle)
        remove
      end

      # Updates the shape's properties; no explicit drawing needed.
      def draw_particle(particle)
        center!(particle.x, particle.y)
        color!(particle.color)
      end

      private

      # Set the shape's center position. Must be implemented per shape.
      # @raise [StandardError] because this method is unimplemented.
      def center!(_centre_x, _centre_y)
        raise StandardError('unimplemented')
      end

      # Set the shape's color.
      #
      # @param [Object] particle_color A colour object with +r+, +g+, +b+, +a+ members,
      #                                where each component is in the range [0.0..1.0].
      def color!(particle_color)
        color.r = particle_color.r
        color.g = particle_color.g
        color.b = particle_color.b
        color.opacity = particle_color.opacity
      end
    end
  end
end
