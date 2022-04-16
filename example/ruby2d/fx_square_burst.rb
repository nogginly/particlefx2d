# frozen_string_literal: true

require 'ruby2d'
require 'particlefx_ruby2d'

# Test particle effect using Ruby2D
class SquareBurstFX
  def self.new_emitter
    ParticleFX2D::Emitter.new(
      renderer_factory: ParticleFX2D::Ruby2D::CanvasRendererFactory.new(
        Canvas.new(x: 10, y: 10, width: Window.width - 20, height: Window.height - 20, update: false)
      ),
      quantity: 200,
      emission_rate: 60,
      particle_config: {
        x: Window.width / 2, x_range: -3.0..3.0,
        y: Window.height - (Window.height / 3), y_range: 0,
        start_color: Color.new([1, 0, 1, 1]),
        end_color: Color.new([1, 1, 1, 0]),
        start_scale: 0.5, end_scale: 3,
        angle: 90, angle_range: -35.0..10.0,
        size: 4.0, size_range: 0,
        speed: 90, speed_range: -10.0..10.0,
        gravity_y: 20, # gravity_x: -6,
        radial_acceleration: -2,
        tangential_acceleration: 10,
        life_time: 7, life_time_range: -1.0..1.0
      }
    )
  end
end

emitter = SquareBurstFX.new_emitter
tick = 0
update do
  frame_time = 1.0 / get(:fps)
  emitter.update frame_time
  tick += 1
  puts emitter.stats if (tick % 60).zero?
end
show
