# ParticleFX2D Change Log

## [Unreleased]

- None so far

## [0.5.0]

- Modified to remove all `require` and `require_relative` calls from the inner source files.
- Instead the outer files (e.g. `particlefx2d.rb`) make sure all the inner files are pulled in the right order.
- Why? A step towards being able to use this with `mruby` (I hope.)

## [0.4.0]

- Added [Math2D](https://github.com/UalaceCafe/math2d) runtime dependency for vector maths
- Tweaked `CanvasRendererFactory` to detect `fill_rectangle` if present

## [0.3.0]

- Defined `Renderer` and `RendererFactory` modules to define how particles are displayed
- Refactors the Ruby2D renderers to define to factories
  - `ShapeRendererFactory` which can be supplied a renderer class (viz. `ParticleCircle` and `ParticleShape`) to generate renderers
  - Preview `CanvasRendererFactory` which can be given a `Ruby2D::Canvas` into which the particle effects are drawn. Consider this _alpha_ because Canvas in Ruby2D is in its early days and currently only support rectangles.
- The existing examples use the `ShapeRendererFactory`
- Added an example [fx_square_burst](example/ruby2d/fx_square_burst.rb) that uses the `CanvasRendererFactory`

## [0.2.0]

- Added some usage documentation to README
- Requiring `particlefx_ruby2d` now automatically brings in `particlefx2d`
- `Particle` properly handles colour arrays as input
- Cleaned up examples

## [0.1.0]

- Initial release
