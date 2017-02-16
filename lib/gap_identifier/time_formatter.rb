module GapIdentifier
  class TimeFormatter
    class << self
      def call(time_in_seconds)
        mm, ss = time_in_seconds.divmod(60)
        hh, mm = mm.divmod(60)
        dd, hh = hh.divmod(24)
        %Q(#{dd} dias, #{hh} horas, #{mm} minutos e #{ss} segundos)
      end
    end
  end
end
