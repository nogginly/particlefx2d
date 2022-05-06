# frozen_string_literal: true

module ParticleFX2D
  module Ruby2D
    #
    # Use an instance of this class to provide
    # an _Emitter_ with a renderer factory.
    class ShapeRendererFactory
      include RendererFactory

      #
      # Instantiate a shape renderer factory.
      #
      # @param [ShapeRenderer] renderer_class Specify the object that will be used to create
      #           the particle renderers. e.g. _ParticleCircle_.
      def initialize(renderer_class)
        @renderer_class = renderer_class
      end

      # Return a particle renderer.
      #
      # @return [Renderer] for each particle
      def renderer_for(particle)
        @renderer_class.for(particle)
      end
    end
  end
end
