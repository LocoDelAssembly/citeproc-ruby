module CiteProc
  module Ruby

    class Renderer

      # @param item [CiteProc::CitationItem]
      # @param node [CSL::Style::Text]
      # @return [String]
      def render_text(item, node)
        case
        when node.has_variable?

          if node.variable == 'locator'

            # Subtle: when there is no locator we also look
            # in item.data; there should be no locator there
            # either but the read access will be noticed by
            # observers (if any).
            text = item.locator || item.data[:locator]

          else
            text = item.data.variable(node.variable, node.variable_options).to_s
          end

          # TODO abbreviate? if node.form = 'short'

          case
          when node.variable == 'page'
            if node.format_page_ranges?
              format_page_range!(text, node.root.page_range_format)
            else
              format_page_range!(text, nil) # replaces page range delimiter
            end

          when node.variable == 'page-first' && text.empty?
            text = item.data[:'page-first'].to_s[/\d+/].to_s

          end

          text

        when node.has_macro?
          render item, node.macro

        when node.has_term?
          translate node[:term], node.attributes_for(:plural, :form)

        else
          node.value.to_s
        end
      end

    end

  end
end
