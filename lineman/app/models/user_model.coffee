angular.module('loomioApp').factory 'UserModel', (BaseModel) ->
  class UserModel extends BaseModel
    @singular: 'user'
    @plural: 'users'
    @uniqueIndices: ['id', 'key']
    @apiEndPoint: 'profile'

    relationships: ->
      # note we should move these to a CurrentUser extends User so that all our authors dont get views created
      @hasMany 'memberships'
      @hasMany 'notifications'
      @hasMany 'contacts'

    membershipFor: (group) ->
      _.first @recordStore.memberships
                          .collection.chain()
                          .find(groupId: group.id)
                          .find(userId: @id).data()

    isMemberOf: (group) ->
      @membershipFor(group)?

    groupIds: ->
      _.map(@memberships(), 'groupId')

    groups: ->
      _.filter @recordStore.groups.find(id: { $in: @groupIds() }), (group) -> !group.isArchived()

    parentGroups: ->
      _.filter @groups(), (group) -> group.parentId == null

    isAuthorOf: (object) ->
      @id == object.authorId

    isAdminOf: (group) ->
      _.contains(group.adminIds(), @id)

    isMemberOf: (group) ->
      _.contains(group.memberIds(), @id)
