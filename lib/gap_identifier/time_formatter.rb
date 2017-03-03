module GapIdentifier
  class TimeFormatter
    class << self
      def call(time_in_seconds)
        mm, ss = time_in_seconds.divmod(60)
        hh, mm = mm.divmod(60)
        dd, hh = hh.divmod(24)
        %Q(#{dd} days, #{hh} hours, #{mm} minutes and #{ss} seconds)
      end
    end
  end
end
