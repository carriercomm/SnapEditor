require ["jquery.custom", "core/contextmenu"], ($, ContextMenu) ->
  $editable = contextmenu = null
  beforeEach ->
    $editable = addEditableFixture()
    api = $("<div/>")
    api.el = $editable
    contextmenu = new ContextMenu(api, {})

  afterEach ->
    $editable.remove()

  describe "ContextMenu", ->
    describe "#tryHide", ->
      $menu = null
      beforeEach ->
        $menu = $('<div id="menu"><div id="item"></div></div>').appendTo($editable)
        contextmenu.id = "menu"
        spyOn(contextmenu, "hide")

      it "does nothing if the target is the menu", ->
        contextmenu.tryHide(target: $menu[0])
        expect(contextmenu.hide).not.toHaveBeenCalled()

      it "does nothing if the target is inside the menu", ->
        contextmenu.tryHide(target: $("#item")[0])
        expect(contextmenu.hide).not.toHaveBeenCalled()

      it "hides the menu", ->
        contextmenu.tryHide(target: $editable[0])
        expect(contextmenu.hide).toHaveBeenCalled()

    describe "#getButtonGroup", ->
      it "throws an error if the context is not default and does not exist", ->
        expect(-> contextmenu.getButtonGroup("doesnotexist")).toThrow()

      it "returns null if the default context does not exist", ->
        expect(contextmenu.getButtonGroup("default")).toBeNull

      it "returns the group of buttons", ->
        contextmenu.config = test: [{ htmlForContextMenu: (-> "<div>text</div>") }, { htmlForContextMenu: (-> "<div>again</div>") }]
        $group = contextmenu.getButtonGroup("test")
        expect($group.children().length).toEqual(2)
        expect($group.children()[0].innerHTML).toEqual("text")
        expect($group.children()[1].innerHTML).toEqual("again")

    describe "#getStyles", ->
      bottomRight = null
      beforeEach ->
        spyOn(contextmenu, "getMenuCoords").andReturn(height: 50, width: 25)
        windowScroll = $(window).getScroll()
        windowSize = $(window).getSize()
        bottomRight =
          x: windowScroll.x + windowSize.x
          y: windowScroll.y + windowSize.y

      it "places the contextmenu where the cursor is", ->
        styles = contextmenu.getStyles(bottomRight.x - 100, bottomRight.y - 150)
        expect(styles.top).toEqual(bottomRight.y - 150)
        expect(styles.left).toEqual(bottomRight.x - 100)

      it "moves the contextmenu up if the cursor is near the bottom", ->
        styles = contextmenu.getStyles(bottomRight.x - 100, bottomRight.y - 5)
        expect(styles.top).toEqual(bottomRight.y - 50)
        expect(styles.left).toEqual(bottomRight.x - 100)

      it "moves the contextmenu to the left if the cursor is near the right side", ->
        styles = contextmenu.getStyles(bottomRight.x - 5, bottomRight.y - 150)
        expect(styles.top).toEqual(bottomRight.y - 150)
        expect(styles.left).toEqual(bottomRight.x - 25)