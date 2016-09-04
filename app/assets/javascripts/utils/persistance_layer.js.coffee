#-----------  Module  -----------#

PersistanceLayer =

  # ---------------
  # Change an attribute's comparison flag
  #
  # @param: {Int} attribute_id
  # @param: {Func} callback
  # @param: {Obj} store - DataStore for callback scope
  # ---------------

  onCellClick: (attribute_id, discrepency, callback, store) ->
    $.ajax(
      url: '/dynamic_values/' + attribute_id
      dataType: 'json'
      data:
        discrepency: discrepency
      method: 'PATCH'
    ).always((data, textStatus) -> return callback.apply(store, [attribute_id, textStatus]))

  # ---------------
  # Select a document as sold
  #
  # @param: {Int} column_id
  # @param: {Func} callback
  # @param: {Obj} store - DataStore for callback scope
  # ---------------

  selectColumnAsSold: (proposalId, callback, store) ->
    projectId = window._DATA.project.id

    $.ajax(
      url: "/projects/#{projectId}/mark_as_sold"
      dataType: 'json'
      data:
        proposal_id: proposalId
      method: 'PATCH'
    ).always((data, textStatus) -> return callback.apply(store, [proposalId, textStatus]))

  # ---------------
  # Archive a document
  #
  # @param: {Int} documentId
  # @param: {Func} callback
  # @param: {Obj} store - DataStore for callback scope
  # ---------------

  archiveColumn: (documentId, callback, store) ->
    projectId = window._DATA.project.id

    $.ajax(
      url: "/projects/#{projectId}/documents/#{documentId}"
      method: 'DELETE'
      dataType: 'json'
    ).always((data, textStatus) -> return callback.apply(store, [documentId, textStatus]))

  # ---------------
  # Unarchive a document
  #
  # @param: {Int} documentId
  # @param: {Func} callback
  # @param: {Obj} store - DataStore for callback scope
  # ---------------

  unarchiveColumn: (documentId, callback, store) ->
    projectId = window._DATA.project.id

    $.ajax(
      url: "/projects/#{projectId}/documents/#{documentId}/unarchive"
      method: 'POST'
      dataType: 'json'
    ).always((data, textStatus) -> return callback.apply(store, [documentId, textStatus]))

  # ---------------
  # Delete a docuemnt (un-finished columns only)
  #
  # @param: {Int} column_id
  # @param: {Func} callback
  # @param: {Obj} store - DataStore for callback scope
  # ---------------

  deleteColumn: (column_id, callback, store) ->
    $.ajax(
      # url: '/dynamic_values/' + attribute_id
      # dataType: 'json'
      # data:
      #   discrepency: discrepency
      # method: 'PATCH'
    ).always((data, textStatus) -> return callback.apply(store, [column_id, textStatus]))

#-----------  Export  -----------#

module.exports = PersistanceLayer
