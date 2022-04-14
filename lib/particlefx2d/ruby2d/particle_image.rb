# frozen_string_literal: true

require_relative 'particle_shape'

module ParticleFX2D
  module Ruby2D
    #
    # A particle shape that is based on the Ruby2D _Image_.
    class ParticleImage < ::Ruby2D::Image
      include ParticleShape

      # This class method is used to identify the image file to load.
      # Create a subclass and override this method to define your own
      # particle shapes based on image files.
      def self.image_path
        "#{File.dirname(__FILE__)}/particle.png"
      end

      # Called by the emitter for each particle that it manages. Creates an instance
      # of _ParticleImage_ using #image_path to obtain the file to load as image and
      # intialized with the particle's position, size and colour.
      #
      # @param [ParticleFX2D::Particle] particle
      #
      def self.for(particle)
        s = ParticleImage.new image_path, width: particle.size, height: particle.size
        s.hide
        s
      end

      # Sets the images's position using the incoming centre coordinates
      # offset by the shape's mid-size.
      def center!(centre_x, centre_y)
        self.x = centre_x - (width / 2)
        self.y = centre_y - (height / 2)
      end

      # Sets the image size using the particle size and calls #super
      def sync!(particle)
        self.width = self.height = particle.size
        super
      end
    end
  end
end
