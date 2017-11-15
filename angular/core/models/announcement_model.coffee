angular.module('loomioApp').factory 'AttachmentModel', (BaseModel) ->
  class AnnouncementModel extends BaseModel
    @singular: 'announcement'
    @plural: 'announcements'
    @indices: ['id', 'userId']
    @serializableAttributes: AppConfig.permittedParams.announcement

    relationships: ->
      @belongsTo 'user'

    model: ->
      @recordStore["#{@announceableType.toLowerCase()}s"].find(@announceableId)