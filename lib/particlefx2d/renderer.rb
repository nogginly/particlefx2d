# frozen_string_literal: true

module ParticleFX2D
  # Defines a particle renderer. Depending on the graphics system used to
  # render the particle effects, you can implement either one single renderer per
  # emitter that does the drawing implement a renderer per particle.
  module Renderer
    # Factory method to provide a renderer for a particle. Called once per particle.
    # The particle system does not care if the factory returns a shared renderer for all the
    # particles or if it returns one per particle. Each particle will be associated with the
    # renderer.
    def self.for(_particle)
      raise StandardError('unimplemented')
    end

    # instance methods per Renderer

    # Notifies the renderer that a particle is visible.
    def show_particle(_particle)
      raise StandardError('unimplemented')
    end

    # Notifies the renderer that a particle is hidden.
    def hide_particle(_particle)
      raise StandardError('unimplemented')
    end

    # Requests the render to draw the particle (or update the particle's rendering
    # peer with the particle's visual attributes.)
    def draw_particle(_particle)
      raise StandardError('unimplemented')
    end
  end
end
