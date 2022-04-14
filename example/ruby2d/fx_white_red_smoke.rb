# frozen_string_literal: true

require 'ruby2d'
require 'particlefx_ruby2d'

# Test particle effect using Ruby2D
class WhiteRedSmokeFX
  def self.new_emitter
    ParticleFX2D::Emitter.new(
      renderer: ParticleFX2D::Ruby2D::ParticleImage,
      quantity: 100,
      emission_rate: 15,
      particle_config: {
        x: Window.width / 2, x_range: -1.0..1.0,
        y: Window.height - (Window.height / 4), y_range: 0,
        start_color: Color.new([1, 1, 1, 1]),
        end_color: Color.new([1, 0, 0, 0]),
        start_scale: 1, end_scale: 2,
        angle: 90, angle_range: -30.0...30.0,
        size: 32, size_range: 0,
        speed: 40, speed_range: 0..15,
        gravity_y: 10, gravity_x: -6,
        life_time: 5, life_time_range: 0..2.0
      }
    )
  end
end

emitter = WhiteRedSmokeFX.new_emitter
tick = 0
update do
  frame_time = 1.0 / get(:fps)
  emitter.update frame_time
  tick += 1
  puts emitter.stats if (tick % 60).zero?
end
show
