angular.module('trackerApp').controller "DashboardController", ($scope, $routeParams, $location, Client) ->

  $scope.init = ->        
    @clientService = new Client(serverErrorHandler)
    $scope.clients = @clientService.all()

  $scope.createClient = (name) ->
    @clientService.create name: name, (client) ->
        $location.url("/clients/#{client.id}")

  $scope.deleteClient = (client, index) ->
    result = confirm "Are you sure you want to remove this reminder?" 

    if result
      @clientService.delete client
      $scope.clients.splice index, 1

  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")
