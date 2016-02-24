module Sprockets
  module Rails
    module Helper
      # Custom view helper used to create an html import. This same method is
      # already defined in ActionView. We pull out the sources here, before
      # calling back to ActionView's.
      #
      # Based on Sprocket's javascript_include_tag.
      def html_import_tag(*sources)
        options = sources.extract_options!.stringify_keys
        integrity = compute_integrity?(options)

        if options["debug"] != false && request_debug_assets?
          sources.map { |source|
            if asset = lookup_debug_asset(source, :type => :html)
              if asset.respond_to?(:to_a)
                asset.to_a.map do |a|
                  super(path_to_html(a.logical_path, :debug => true), options)
                end
              else
                super(path_to_html(asset.logical_path, :debug => true), options)
              end
            else
              super(source, options)
            end
          }.flatten.uniq.join("\n").html_safe
        else
          sources.map { |source|
            options = options.merge('integrity' => asset_integrity(source, :type => :html)) if integrity
            super source, options
          }.join("\n").html_safe
        end
      end
    end
  end
end
