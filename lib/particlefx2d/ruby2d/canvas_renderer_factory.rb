# frozen_string_literal: true

require_relative '../renderer_factory'

module ParticleFX2D
  module Ruby2D
    # A shared surface renderer that uses Ruby2D's _Canvas_ to draw into. This is both
    # a factory and the renderer/
    #
    # This approach uses the same renderer for all particles in an emitter.
    class CanvasRendererFactory
      include ParticleFX2D::RendererFactory
      include ParticleFX2D::Renderer

      # ----- Factory

      # Instantiate a shape renderer factory.
      #
      # @param [Ruby2D::Canvas] canvas The partice effects will be drawn into this canvas. Disable auto-update for
      #                                the Canvas so that each attempt to draw into it will not cause a texture update.
      def initialize(canvas)
        @canvas = canvas
      end

      # Return a particle renderer.
      #
      # @return [Renderer] for each particle
      def renderer_for(_particle)
        self
      end

      # Clear the canvas before the next update cycle
      def on_update_start
        @canvas.draw_rectangle(x: 0, y: 0,
                               width: @canvas.width, height: @canvas.height,
                               color: [0, 0, 0, 0])
      end

      # Update the canvas at the end of the next update cycle
      def on_update_end
        @canvas.update
      end

      # ----- Renderer

      # Show the particle. Used when a particle is activated.
      def show_particle(_particle); end

      # Hide the particle. Used when a particle is deactivated.
      def hide_particle(_particle); end

      # Updates the shape's properties; no explicit drawing needed.
      def draw_particle(particle)
        size = particle.size
        x = particle.x - (size / 2)
        y = particle.y - (size / 2)
        @canvas.draw_rectangle(x: x, y: y,
                               width: size, height: size,
                               color: particle.color.to_a)
      end
    end
  end
end
