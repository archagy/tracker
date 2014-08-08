angular.module('trackerApp').factory 'Client', ($resource, $http) ->
  class Client
    constructor: (errorHandler) ->
      @service = $resource('/api/clients/:id',
        {id: '@id'},
        {update: {method: 'PATCH'}})
      @errorHandler = errorHandler

      # Fix needed for the PATCH method to use application/json content type.
      defaults = $http.defaults.headers
      defaults.patch = defaults.patch || {}
      defaults.patch['Content-Type'] = 'application/json'

    create: (attrs, successHandler) ->
      new @service(client: attrs).$save ((client) -> successHandler(client)), @errorHandler      

    delete: (client) ->
      new @service().$delete {id: client.id}, (-> null), @errorHandler

    update: (client, attrs) ->
      new @service(client: attrs).$update {id: client.id}, (-> null), @errorHandler
      
    all: ->
      @service.query((-> null), @errorHandler)


    find: (id, successHandler) ->
      @service.get(id: id, ((client)-> 
        successHandler?(client)
        client), 
       @errorHandler)
