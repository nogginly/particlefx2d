# frozen_string_literal: true

module ParticleFX2D
  # @!visibility private
  module Private
    # @!visibility private
    #
    # A 2D vector, for internal use only
    #
    class Vector2
      attr_reader :x, :y

      def self.copy(vector)
        Vector.new(vector.x, vector.y)
      end

      def initialize(x = 0, y = 0)
        @x = x
        @y = y
      end

      def set!(x, y)
        @x = x
        @y = y
        self
      end

      def copy!(other)
        @x = other.x
        @y = other.y
        self
      end

      def add!(x, y)
        @x += x
        @y += y
        self
      end

      def subtract!(x, y)
        @x -= x
        @y -= y
        self
      end

      def times!(value)
        @x *= value
        @y *= value
        self
      end

      def divide_by!(value)
        @x /= value
        @y /= value
        self
      end

      def add_vector!(other)
        @x += other.x
        @y += other.y
        self
      end

      def minus_vector!(other)
        @x -= other.x
        @y -= other.y
        self
      end

      def magnitude
        Math.sqrt(@x.abs2 + @y.abs2)
      end

      def cross!
        set! @y, -@x
      end

      def normalize!
        mag = magnitude
        mag = Float::INFINITY if mag.zero?
        divide_by! mag
      end
    end
  end
end
