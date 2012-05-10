module Analytical
  module Modules
    class SegmentIo
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Segment.io -->
          <script type="text/javascript">
              var seg = seg || [];
                  seg.load = function (url) {
                    var s, f, a, b, c, d = document;
                    s = d.createElement('script');
                    s.type = 'text/javascript'; s.async = true; s.src = url;
                    f = d.getElementsByTagName('script')[0]; f.parentNode.insertBefore(s, f);
                    a = function (t) {
                        return function () {
                            seg.push([t].concat(Array.prototype.slice.call(arguments, 0)));
                        };
                    };
                    b = ['init', 'identify', 'track', 'callback', 'verbose'];
                    for(c = 0; c < b.length; c += 1) {
                        seg[b[c]]=a(b[c]);
                    }
                };
              seg.load(document.location.protocol + '//d47xnnr8b1rki.cloudfront.net/api/js/v2/segmentio.js');
              //seg.verbose(true); // remove this in production to turn off logging
              seg.init('#{options[:js_url_key]}'); // Your API key goes here
          </script>
          HTML
          js
        end
      end

      def identify(id, *args)
        name = args.shift || {}
        data = args || {}
        "seg.identify(\"#{name}\", #{data.to_a});"
      end

      def event(name, *args)
        data = args.first || {}
        "seg.track(\"#{name}\", #{data.to_a});"
      end
    end
  end
end
