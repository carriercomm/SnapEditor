# Copyright (c) 2012-2013 8098182 Canada Inc. All rights reserved.
# For licensing, see LICENSE.
#
# Handles when there is nothing inside the editor and we want to create the
# starting default tag (usually a P tag)
define ["snapeditor.pre", "jquery.custom", "core/helpers"], (SnapEditor, $, Helpers) ->
  emptyHandler =
    activate: (@api) ->
      self = this
      @onkeyupHandler = -> (e) -> self.onkeyup(e)
      @api.on("snapeditor.keyup", @onkeyupHandler)

    deactivate: ->
      @api.off("snapeditor.keyup", @onkeyupHandler)

    onkeyup: (e) ->
      key = Helpers.keyOf(e)
      if (key == 'delete' or key == 'backspace') and Helpers.isEmpty(@api.el)
        @deleteAll()

    # After the cleaner has finished, insert the default block if the editor is
    # empty. This is because in some editors, when there is no content,
    # the editor keeps around the last styling mode like H1, H2 or H3 so that
    # when you start typing in an empty contentEditable, you don't start 
    # with a P tag.
    onCleanerFinished: (@api) ->
      @deleteAll() if Helpers.isEmpty(@api.el)

    # Removes all content and appends the default block. It then places the
    # selection at the end of the block.
    deleteAll: ->
      # Keep track of the cursor position.
      start = @api.find("#RANGE_START")[0]
      end = @api.find("#RANGE_END")[0]
      $(@api.el).empty()
      block = $(@api.getDefaultBlock()).html(Helpers.zeroWidthNoBreakSpace)[0]
      @api.el.appendChild(block)
      if start and end
        # If the cursor position is being preserved, make sure to add them
        # back in.
        block.appendChild(start)
        block.appendChild(end)
      else
        # If no cursor position is being preserved, set the selection to the
        # end of the block if the range is currently valid.
        @api.selectEndOfElement(block) if @api.isValid()

  SnapEditor.behaviours.emptyHandler =
      onActivate: (e) -> emptyHandler.activate(e.api)
      onDeactivate: (e) -> emptyHandler.deactivate()
      onCleanerFinished: (e) -> emptyHandler.onCleanerFinished(e.api)

  # emptyHandler is returned for testing purposes.
  return emptyHandler
