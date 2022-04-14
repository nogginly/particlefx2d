# frozen_string_literal: true

require 'ruby2d'
require 'particlefx_ruby2d'
require 'particlefx2d'

# Test particle effect using Ruby2D
class BlueSwirlingSmokeFX
  def self.new_emitter
    ParticleFX2D::Emitter.new(
      renderer: ParticleFX2D::Ruby2D::ParticleImage,
      quantity: 200,
      emission_rate: 200,
      particle_config: {
        x: Window.width / 2, x_range: -10.0..10.0,
        y: Window.height / 2, y_range: -5.0..5.0,
        start_color: Color.new([0.5, 0.5, 1, 1]),
        end_color: Color.new([0, 0, 0, 1]),
        angle: 0, angle_range: 0.0..360.0,
        size: 32, size_range: 4,
        start_scale: 0.5, end_scale: 1.5,
        speed: 10, speed_range: 0..5,
        radial_acceleration: -3,
        tangential_acceleration: 6,
        life_time: 6, life_time_range: 0..2.0
      }
    )
  end
end

emitter = BlueSwirlingSmokeFX.new_emitter
tick = 0
update do
  frame_time = 1.0 / get(:fps)
  emitter.update frame_time
  tick += 1
  puts emitter.stats if (tick % 60).zero?
end
show
