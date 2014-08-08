angular.module('trackerApp').factory 'Reminder', ($resource, $http) ->
  class Reminder
    constructor: (clientId, errorHandler) ->
      @service = $resource('/api/clients/:client_id/reminders/:id',
        {client_id: clientId, id: '@id'},
        {update: {method: 'PATCH'}})
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    create: (attrs) ->
      new @service(reminder: attrs).$save ((reminder) -> attrs.id = reminder.id), @errorHandler
      attrs

    delete: (reminder) ->
      new @service().$delete {id: reminder.id}, (-> null), @errorHandler

    update: (reminder, attrs) ->
      new @service(reminder: attrs).$update {id: reminder.id}, (-> null), @errorHandler

    all: ->
      @service.query((-> null), @errorHandler)