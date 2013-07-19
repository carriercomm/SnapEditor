define ["jquery.custom"], ($) ->
  class Button
    # Options:
    # text - used as the title for the button and the text for submenus when
    #   html is not present
    # html - used for submenus
    # action - a function to execute or a key to SnapEditor.actions (ignored
    #   if items is defined)
    # items - array of SnapEditor.buttons or function that returns an array of
    #   SnapEditor.buttons
    # onInclude - a function to execute when the button is included
    constructor: (@name, options) ->
      $.extend(this, options)
      @cleanName = @name.replace(/\./g, "_")
      # If items is an array, change it to a function that returns the array.
      if $.type(@items) == "array"
        # We duplicate the array so that we don't modify the original one.
        items = @items.slice(0)
        @items = -> items

    # Default items.
    items: (e) ->
      []

    # A nicer alias for items().
    getItems: (e) ->
      @items(e)

    # items - array of strings
    appendItems: (items) ->
      oldItems = @items
      @items = (e) -> oldItems(e).concat(items)