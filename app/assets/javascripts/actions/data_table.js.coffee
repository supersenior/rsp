#-----------  Requirements  -----------#

DataTableConstants  = require('constants/data_table')
DataTableDispatcher = require('dispatchers/data_table')

ActionTypes = DataTableConstants.ActionTypes

#-----------  Module  -----------#

DataTableActions =

  changeFilters: (selected_product, selected_class, show_advanced) ->
    DataTableDispatcher.dispatch
      type            : ActionTypes.CHANGE_FILTERS
      selectedProduct : selected_product
      selectedClass   : selected_class
      showAdvanced    : show_advanced

  toggleAttributelDiscrepency: (attribute_id, column_id, discrepency) ->
    DataTableDispatcher.dispatch
      type        : ActionTypes.CHANGE_ATTRIBUTE_DISCREPENCY
      attributeID : attribute_id
      columnID    : column_id
      discrepency : discrepency

  toggleRowCollapse: (row_id, is_collapsed) ->
    DataTableDispatcher.dispatch
      type        : ActionTypes.COLLAPSE_ROW
      rowID       : row_id
      isCollapsed : is_collapsed

  changeProductVolume: (volume) ->
    DataTableDispatcher.dispatch
      type   : ActionTypes.CHANGE_PRODUCT_VOLUME
      volume : volume

  resortColumn: (column_id, from_index, to_index) ->
    DataTableDispatcher.dispatch
      type      : ActionTypes.RESORT_COLUMN
      columnID  : column_id
      fromIndex : from_index
      toIndex   : to_index

  archiveColumn: (column_id) ->
    DataTableDispatcher.dispatch
      type     : ActionTypes.ARCHIVE_COLUMN
      columnID : column_id

  selectColumnAsSold: (column_id) ->
    DataTableDispatcher.dispatch
      type     : ActionTypes.SELECT_COLUMN_AS_SOLD
      columnID : column_id

  deleteColumn: (column_id) ->
    DataTableDispatcher.dispatch
      type     : ActionTypes.DELETE_COLUMN
      columnID : column_id

#-----------  Export  -----------#

module.exports = DataTableActions
