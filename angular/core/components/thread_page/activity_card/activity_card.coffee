angular.module('loomioApp').directive 'activityCard', (ChronologicalEventWindow, NestedEventWindow, RecordLoader, $mdDialog, $timeout, $window, $location, AbilityService)->
  scope: {discussion: '=', loading: '=', activeCommentId: '=?'}
  restrict: 'E'
  templateUrl: 'generated/components/thread_page/activity_card/activity_card.html'
  replace: true
  controller: ($scope) ->
    $scope.$on 'fetchRecordsForPrint', (event, options = {}) ->
      $scope.tw.loadAll().then ->
        $mdDialog.cancel()
        $timeout -> $window.print()

    $scope.discussion.markAsSeen()

    $scope.per = 10
    $scope.renderMode = "nested"

    $scope.initialSequenceId = do ->
      #load from: from, scrollTo: from
      return $location.search().from                   if $location.search().from      # respond to ?from parameter
      # load from 1, scroll to nothing
      return $scope.discussion.firstSequenceId()       if !AbilityService.isLoggedIn() # show beginning of discussion for logged out users
      # load from 2 back, sroll to latestActivity
      return $scope.discussion.firstUnreadSequenceId() if $scope.discussion.isUnread() # show newest unread content for logged in users
      # load last page, scroll to end
      return $scope.discussion.lastSequenceId() - $scope.per + 2               # show latest content if the discussion has been read

    $scope.loader = new RecordLoader
      collection: 'events'
      params:
        discussion_id: $scope.discussion.id
        order: 'sequence_id'
        from: $scope.initialSequenceId
        per: $scope.per

    $scope.init = ->
      $scope.loader.loadMore().then ->
        if $scope.renderMode == "chronological"
          $scope.eventWindow = new ChronologicalEventWindow
            discussion: $scope.discussion
            initialSequenceId: $scope.initialSequenceId
            per: $scope.per
        else
          $scope.eventWindow = new NestedEventWindow
            discussion: $scope.discussion
            parentEvent: $scope.discussion.createdEvent()
            initialSequenceId: $scope.initialSequenceId
            per: $scope.per

        $scope.$emit('threadPageEventsLoaded')

    $scope.init()

    return
