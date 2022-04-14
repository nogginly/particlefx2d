# frozen_string_literal: true

#
# 2D Particle Effects
#
module ParticleFX2D
  # @!visibility private
  module Private
    # @!visibility private
    #
    # RGBA colour representation by its four components, for internal use only.
    #
    class Color
      attr_accessor :r, :g, :b, :a

      def initialize(other)
        case other
        when Array
          @r = other[0].to_f
          @g = other[1].to_f
          @b = other[2].to_f
          @a = other[3].to_f
        else
          @r = other.r
          @g = other.g
          @b = other.b
          @a = other.a
        end
      end

      alias opacity a
      alias opacity= a=

      def to_a
        [@r, @g, @b, @a]
      end

      def subtract!(other)
        case other
        when Numeric
          @r -= other
          @g -= other
          @b -= other
          @a -= other
        else
          @r -= other.r
          @g -= other.g
          @b -= other.b
          @a -= other.a
        end
        self
      end

      def add!(other, each_times: 1)
        case other
        when Numeric
          value = other * each_times
          @r += value
          @g += value
          @b += value
          @a += value
        else
          @r += other.r * each_times
          @g += other.g * each_times
          @b += other.b * each_times
          @a += other.a * each_times
        end
        self
      end

      def divide_by!(other)
        case other
        when Numeric
          @r /= other
          @g /= other
          @b /= other
          @a /= other
        else
          @r /= other.r
          @g /= other.g
          @b /= other.b
          @a /= other.a
        end
        self
      end
    end
  end
end
