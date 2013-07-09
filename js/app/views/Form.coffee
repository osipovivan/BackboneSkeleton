define (require, exports, module) ->
  Backbone = require "backbone"
  Item = require "cs!views/form/FormItem"
  Button = require "cs!views/form/Button"
  class Form extends Backbone.View
    tagName: "form"
    constructor: ->
      Backbone.View.apply @, arguments
      if (@options.model?)
        @options.model.on "invalid", (model, errors) =>
          for index, error of errors
            @items[error.field].showError error.message if (@items[error.field]?)

    render: ->
      for item in @options.items then do (item) =>
        items = @items ?= {}
        items[item.name] = new Item item
        items[item.name].render()
        $(@el).append items[item.name].el
      if (@options.buttons?)
        buttonsItem = new Item {type: "button"}
        buttonsItem.render()
        buttonsElement = $(buttonsItem.el).find(".controls")
        for item in @options.buttons then do (item) =>
          buttons = @buttons ?= {}
          buttons[item.name] = new Button item
          buttons[item.name].render()
          buttonsElement.append buttons[item.name].el
          buttonsElement.append "&nbsp;"

        $(@el).append buttonsItem.el
      return this

    getValues: ->
      values = {}
      for key, value of @items
        values[key] = $(value.el).find("#" + key).val()
      return values
  module.exports = Form