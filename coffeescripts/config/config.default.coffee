define ["plugins/activate/activate", "plugins/deactivate/deactivate", "plugins/editable/editable", "plugins/cleaner/cleaner", "plugins/erase_handler/erase_handler", "plugins/enter_handler/enter_handler", "plugins/empty_handler/empty_handler", "plugins/edit/edit", "plugins/inline/inline", "plugins/block/block", "plugins/link/link", "plugins/list/list", "plugins/dent/dent", "plugins/table/table"], (Activate, Deactivate, Editable, Cleaner, EraseHandler, EnterHandler, EmptyHandler, Edit, Inline, Block, Link, List, Dent, Table) ->
  return {
    build: ->
      return {
        plugins: [new Activate(), new Deactivate(), new Editable(), new Cleaner(), new EraseHandler(), new EnterHandler(), new EmptyHandler(), new Edit(), new Inline(), new Block(), new Link(), new List(), new Dent(), new Table()]
        toolbar: [
          "Inline", "|"
          "Block", "|"
          "List", "Dent", "|",
          "Link", "Table"
        ]
        whitelist: {
          # Blocks
          "Paragraph": "p > Paragraph"
          "Div": "div > Div"
          # Headings
          "Heading 1": "h1 > Paragraph"
          "Heading 2": "h2 > Paragraph"
          "Heading 3": "h3 > Paragraph"
          # Lists
          "Unordered List": "ul"
          "Ordered List": "ol"
          "List Item": "li > List Item"
          # Tables
          "Table": "table"
          "Table Body": "tbody"
          "Table Row": "tr"
          "Table Header": "th > BR"
          "Table Cell": "td > BR"
          # BR
          "BR": "br"
          # Inlines
          "Bold": "b"
          "Italic": "i"
          "Links": "a[href]"
          "Range Start": "span#RANGE_START"
          "Range End": "span#RANGE_END"
          # Defaults
          "*": "Paragraph"
          "strong": "Bold"
          "em": "Italic"
        }
      }
  }
