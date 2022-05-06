# frozen_string_literal: true

module ParticleFX2D
  module Ruby2D
    #
    # A particle shape that is based on the Ruby2D _Circle_ shape.
    class ParticleCircle < ::Ruby2D::Circle
      include ShapeRenderer

      # Called by the emitter for each particle that it manages. Creates an instance
      # of _ParticleCircle_ intialized with the particle's position, size and colour.
      #
      # @param [ParticleFX2D::Particle] particle
      #
      def self.for(particle)
        s = ParticleCircle.new x: particle.x, y: particle.y,
                               radius: particle.size / 2
        s.color! particle.color
        s.remove
        s
      end

      # Sets the circle's position using the incoming centre coordinates.
      def center!(centre_x, centre_y)
        self.x = centre_x
        self.y = centre_y
      end

      # Sets the radius using the particle size and calls #super
      def draw_particle(particle)
        self.radius = particle.size / 2
        super
      end
    end
  end
end
