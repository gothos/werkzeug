goog.require 'wzk.ui.ac.InputHandler'
goog.require 'wzk.ui.ac.PictureCustomRenderer'
goog.require 'wzk.ui.ac.ArrayMatcher'
goog.require 'wzk.ui.ac.AutoComplete'
goog.require 'wzk.ui.ac.SelectOneStorage'

class wzk.ui.ac.SelectAutoComplete

  ###*
    Select is assumed to be prepopulated with options in templated

    @param {wzk.dom.Dom} dom
    @param {wzk.ui.ac.Renderer} renderer
  ###
  constructor: (@dom, @renderer) ->
    @select = null
    @handler = null
    @stro = null

  ###*
    @protected
    @param {Array.<wzk.resource.Model>} data
  ###
  findDefaultValue: (data) ->
    model = @stor.load data
    if model?
      @setDefaultValue model

  ###*
    @protected
    @param {wzk.resource.Model} model
  ###
  setDefaultValue: (model) ->
    input = @renderer.getInput()
    @handler.detachInput input.getElement()
    input.setValue model.toString()
    @handler.attachInput input.getElement()

    @afterSelect model

  ###*
    @param {Element} select
  ###
  decorate: (@select) ->
    @renderer.decorate @select
    @stor = new wzk.ui.ac.SelectOneStorage @dom, @select

  ###*
    @param {Array} data
  ###
  load: (data) ->
    matcher = new wzk.ui.ac.ArrayMatcher data, false
    @handler = new wzk.ui.ac.InputHandler null, null, false
    ac = new wzk.ui.ac.AutoComplete matcher, @renderer, @handler

    @handler.attachAutoComplete ac
    @handler.attachInput @renderer.getInput().getElement()

    ac.listen goog.ui.ac.AutoComplete.EventType.UPDATE, @handleUpdate

    @findDefaultValue data

  ###*
    @protected
    @param {goog.events.Event} e
  ###
  handleUpdate: (e) =>
    @stor.store e.row
    @afterSelect e.row

  ###*
    @protected
    @param {Object} row
  ###
  afterSelect: (row) ->
    @renderer.updateImage row