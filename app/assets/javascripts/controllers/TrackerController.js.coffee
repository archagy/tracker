angular.module('trackerApp').controller "TrackerController", ($scope, $timeout, $routeParams, Reminder, Client) ->
  $scope.sortMethod = 'priority'
  $scope.sortableEnabled = true

  $scope.init = () ->
    @reminderService = new Reminder($routeParams.client_id, serverErrorHandler)
    @clientService = new Client(serverErrorHandler)

    $scope.client = @clientService.find $routeParams.client_id

  $scope.addReminder = ->
    raisePriorities()
    reminder = @reminderService.create(description: $scope.reminderDescription)
    reminder.priority = 1
    $scope.client.reminders.unshift(reminder)
    $scope.reminderDescription = ""

  $scope.deleteReminder = (reminder) ->
    lowerPrioritiesBelow(reminder)
    @reminderService.delete(reminder)
    $scope.client.reminders.splice($scope.client.reminders.indexOf(reminder), 1)

  $scope.toggleReminder = (reminder) ->
    @reminderService.update(reminder, completed: reminder.completed)

  $scope.clientNameEdited = (clientName) ->
    @clientService.update(@client, name: clientName)

  $scope.reminderEdited = (reminder) ->
    @reminderService.update(reminder, description: reminder.description)

  $scope.dueDatePicked = (reminder) ->
    @reminderService.update(reminder, date: reminder.date)

  $scope.priorityChanged = (reminder) ->
    @reminderService.update(reminder, target_priority: reminder.priority)
    updatePriorities()

  $scope.sortableOptions =
    update: (e, ui) ->
      domIndexOf = (e) -> e.siblings().andSelf().index(e)
      newPriority = domIndexOf(ui.item) + 1

      reminder = ui.item.scope().reminder
      reminder.priority = newPriority

      $scope.priorityChanged(reminder)

  $scope.changeSortMethod = (sortMethod) ->
    $scope.sortMethod = sortMethod
    if sortMethod == 'priority'
      $scope.sortableEnabled = true
    else
      $scope.sortableEnabled = false

  $scope.dueDateNullLast = (reminder) ->
    reminder.date ? '2999-12-31'

  serverErrorHandler = ->
    alert("There was a server error, please reload the page and try again.")

  updatePriorities = ->
    # During reordering it's simplest to just mirror priorities based on task
    # positions in the list.
    $timeout ->
      angular.forEach $scope.client.reminders, (reminder, index) ->
        reminder.priority = index + 1

  raisePriorities = ->
    angular.forEach $scope.client.reminders, (t) -> t.priority += 1

  lowerPrioritiesBelow = (reminder) ->
    angular.forEach remindersBelow(reminder), (t) ->
      t.priority -= 1

  remindersBelow = (reminder) ->
    $scope.client.reminders.slice($scope.client.reminders.indexOf(reminder), $scope.client.reminders.length)