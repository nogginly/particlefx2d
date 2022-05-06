# frozen_string_literal: true

module ParticleFX2D
  # Defines a RendererFactory. Each emitter should have it's own
  # factory which is called once per particle to create a Renderer.
  # It is possible for a factory to
  # * EITHER return the same Renderer for all particles and handle the drawing for the particles;
  # * OR return a renderer per particle.
  module RendererFactory
    # Return a particle renderer.
    #
    # @return [Renderer] for each particle
    def renderer_for(_particle)
      raise StandardError('unimplemented')
    end

    #
    # Called once per update cycle by the emitter to let the factory know that
    # all the particles are about to be updated and redrawn.
    # A shared renderer factory can use this to clear the underlying surface, for example.
    # A per-particle renderer factory can ignore this method as by default it does nothing.
    def on_update_start
      # Does nothing by default.
    end

    #
    # Called once per update cycle by the emitter to let the factory know that
    # an update cycle is complete.
    # A shared renderer factory can use this to commit the changes made, for example.
    # A per-particle renderer factory can ignore this method as by default it does nothing.
    def on_update_end
      # Does nothing by default.
    end
  end
end
