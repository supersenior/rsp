#-----------  Requirements  -----------#

DataTableConstants  = require('constants/data_table')
DataTableDispatcher = require('dispatchers/data_table')
LocalStorageAdapter = require('utils/local_storage_adapter')
ProjectSerializer   = require('utils/project_serializer')
PersistanceLayer    = require('utils/persistance_layer')

isColumnVisible = require('utils/utility_functions').isColumnVisible
isUsableNumber  = require('utils/utility_functions').isUsableNumber
EventEmitter    = require('events').EventEmitter
assign          = require('object-assign')

ActionTypes  = DataTableConstants.ActionTypes
CHANGE_EVENT = 'change'

#-----------  Module  -----------#

DataTableStore = assign {}, EventEmitter.prototype,

  init: ->
    @_project = window._DATA.project # TODO: possibly make this an ajax call?

    serializer = new ProjectSerializer(@_project)
    LocalStorageAdapter.storageInitialization(@_project.id)

    @_columns  = serializer.columns
    @_products = serializer.products
    @_rows     = serializer.rows

    @_setColumnOrder()
    @_setNonContributoryProducts()
    @_setComparisonRates()
    @_setSortableBounds()
    @_setFilters()
    @_setSold()

  #-----------  Dynamic Setters  -----------#

  _setFilters: (selected_product, selected_class, show_advanced) ->
    @_currentProduct = selected_product || @_defaultProduct()
    @_currentClass   = selected_class || @_defaultClass()
    @_showAdvanced   = if _.isBoolean(show_advanced) then show_advanced else @getAdvancedToggle()

  _setColumnOrder: ->
    columns = @getColumns()
    order = LocalStorageAdapter.getColumnsorting()

    return false if _.isEmpty(order)

    visible_columns = []
    pending_columns = []

    # sort previously order columns
    for column_id in order
      column = _.findWhere(columns, {id: column_id})
      if column
        if isColumnVisible(column)
          visible_columns.push(column)
        else
          pending_columns.push(column)

    # sort previously order columns
    for column in columns
      if (column && _.indexOf(order, column.id) == -1)
        if isColumnVisible(column)
          visible_columns.push(column)
        else
          pending_columns.push(column)

    # combine ordered columns
    ordered_columns = visible_columns.concat(pending_columns)

    # update stores
    updated_id_array = _.map(ordered_columns, (column) -> return column.id)
    LocalStorageAdapter.setColumnSorting(updated_id_array)
    @_columns = ordered_columns

  #-----------  Static Setters  -----------#

  _setSortableBounds: ->
    columns = @getColumns()
    has_policy = _.find(columns, (column) -> column.document_type == 'Policy')
    finalized_proposal_count = _.countBy(columns, (column) -> return (column.document_type == 'Proposal' && column.state == 'finalized'))
    buffer = if has_policy then 1 else 0

    if has_policy
      @_leftSortableBound = 1
      @_rightSortableBound = finalized_proposal_count.true || 1
    else
      @_leftSortableBound = 0
      @_rightSortableBound = (finalized_proposal_count.true - 1) || 0

  _setComparisonRates: ->
    @_comparisonRates = []
    comparison_column = _.findWhere(@_columns, { document_type: 'Policy' })
    if comparison_column
      @_comparisonRates = _.mapObject comparison_column.product_information, (information, product_id) ->
        return information.unit_rate

  _setNonContributoryProducts: ->
    @_nonContributoryProducts = _.filter @_products, (product) ->
      return product.has_non_contributory

  _setSold: ->
    @_hasSold = !_.isEmpty(_.findWhere(@getColumns(), { is_sold: true }))

  #-----------  Default Setters  -----------#

  _defaultProduct: ->
    for product in @getOrderedProducts()
      return product.product_id unless _.isEmpty(product.product_classes)
    return ''

  _defaultClass: ->
    default_product_array = @getProducts()[@_defaultProduct()] || []
    for klass_id, klass of default_product_array.product_classes
      return klass_id
    return ''

  #-----------  Simple Getters  -----------#

  getRows: ->
    return @_rows

  getColumns: ->
    return @_columns

  getOrderedProducts: ->
    return _.sortBy(_.sortBy(_.values(@getProducts()), 'name'), 'product_position')

  getProducts: ->
    return @_products

  hasSoldProposal: ->
    return @_hasSold

  getCurrentProduct: ->
    return @_currentProduct

  getCurrentClass: ->
    return @_currentClass

  getComparisonRates: ->
    return @_comparisonRates

  getLeftSortableBound: ->
    return @_leftSortableBound

  getRightSortableBound: ->
    return @_rightSortableBound

  getNonContributoryProducts: ->
    return @_nonContributoryProducts

  #-----------  Getters  -----------#

  getFilteredRows: ->
    filteredRows = @getRows()[@getCurrentProduct()][@getCurrentClass()] || []

    return (if @getAdvancedToggle() then filteredRows else _.filter filteredRows, (row) -> return !row['sidebar'].is_advanced)

  getVisibleColumns: ->
    columns = @getColumns()
    return _.filter columns, (column) -> return isColumnVisible(column)

  getAdvancedToggle: ->
    product_id = @getCurrentProduct()
    return LocalStorageAdapter.isAdvancedProduct(product_id)

  getProductVolume: ->
    product_id = @getCurrentProduct()
    return LocalStorageAdapter.getProductVolume(product_id)

  getComparisonRate: ->
    product_id = @getCurrentProduct()
    return @getComparisonRates()[product_id] || null

  getColumnsingleProductInformation: (column_id) ->
    product_info = _.findWhere(@_columns, { id: column_id }).product_information || {}
    return product_info[@getCurrentProduct()] || {}

  getColumnAllProductInformation: (column_id) ->
    product_info = _.findWhere(@_columns, { id: column_id }).product_information || {}
    return product_info

  getProductDenominators: ->
    products     = @getNonContributoryProducts()
    columns      = @getVisibleColumns()
    denominators = {}

    for product in products
      product_id = product.product_id
      denominators[product_id] = null

      for column in columns
        if column.product_information
          if column.product_information[product_id]
            value = column.product_information[product_id].rate_denominator
            denominators[product_id] = value if isUsableNumber(value)

    return denominators

  #-----------  Checks  -----------#

  isProductNonConributory: (product_id = 0) ->
    product_id = product_id || @getCurrentProduct()
    return @getProducts()[product_id].has_non_contributory

  #-----------  Hieght Calculations  -----------#

  calculateRowHieght: (row_object) ->
    row_id = row_object.sidebar.row_id || null

    if row_object.sidebar.is_grouping
      return 30
    else if LocalStorageAdapter.isRowCollapsed(row_id)
      return 12
    else
      height = 50
      row_count = 0

      for index, column of @getColumns()
        if row_object[column.id]
          entry = row_object[column.id].value || ''

          if _.isObject(entry)
            # object entries (ex. age-banded rates)
            rows = _.keys(entry).length
            if rows > row_count
              row_count = rows
              height = parseInt((rows * 27.4) + 12)

          else if entry.length > 60
            # long string entries
            # TODO: make more robust calculation
            lines = Math.ceil(entry.length/28)
            entry_height = (lines * 15) + 20
            height = entry_height if (entry_height > height)

      return height

  calculateFooterHeight: (is_expanded = false) ->
    if is_expanded
      nonContributaryProductCount = DataTableStore.getNonContributoryProducts().length || 0
      footerHeight = (60 * nonContributaryProductCount) + 76
    else if @isProductNonConributory()
      return 136
    else
      return 38

  #-----------  Change Listeners  -----------#

  _emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

  #-----------  Action Handlers  -----------#

  _toggleAttributelDiscrepency: (attribute_id, column_id, discrepency) ->
    product = @getCurrentProduct()
    klass = @getCurrentClass()

    for index, row of @getRows()[product][klass]
      if row[column_id].id == attribute_id
        return @_rows[product][klass][index][column_id].discrepency = discrepency

  #-----------  AJAX Callbacks  -----------#

  _toggleAttributelDiscrepencyCallback: (attribute_id, message = '') ->
    # TODO: do something w/ error states
    return false

  _selectColumnAsSoldCallback: (column_id, message = '') ->
    # TODO: do something w/ error states
    return @_emitChange()

#-----------  Event Dispatchers  -----------#

DataTableStore.dispatchToken = DataTableDispatcher.register (action) ->

  switch action.type

    when ActionTypes.CHANGE_FILTERS
      LocalStorageAdapter.toggleAdvancedProduct(action.selectedProduct, action.showAdvanced) if _.isBoolean(action.showAdvanced)
      DataTableStore._setFilters(action.selectedProduct, action.selectedClass, action.showAdvanced)
      DataTableStore._emitChange()

    when ActionTypes.CHANGE_ATTRIBUTE_DISCREPENCY
      callback = DataTableStore._toggleAttributelDiscrepencyCallback
      PersistanceLayer.onCellClick(action.attributeID, action.discrepency, callback, DataTableStore)
      DataTableStore._toggleAttributelDiscrepency(action.attributeID, action.columnID, action.discrepency)
      DataTableStore._emitChange()

    when ActionTypes.COLLAPSE_ROW
      LocalStorageAdapter.toggleCollapsedRow(action.rowID, action.isCollapsed)
      DataTableStore._emitChange()

    when ActionTypes.CHANGE_PRODUCT_VOLUME
      product_id = DataTableStore.getCurrentProduct()
      LocalStorageAdapter.setProductVolume(product_id, action.volume)
      DataTableStore._emitChange()

    when ActionTypes.RESORT_COLUMN
      columns = DataTableStore.getColumns()
      LocalStorageAdapter.resortColumns(action.columnID, action.fromIndex, action.toIndex, columns)
      DataTableStore._setColumnOrder()
      DataTableStore._emitChange()

    when ActionTypes.ARCHIVE_COLUMN
      callback = location.reload
      PersistanceLayer.archiveColumn(action.columnID, callback, window.location)

    when ActionTypes.SELECT_COLUMN_AS_SOLD
      callback = location.reload
      PersistanceLayer.selectColumnAsSold(action.columnID, callback, window.location)

    when ActionTypes.DELETE_COLUMN
      callback = location.reload
      PersistanceLayer.deleteColumn(action.columnID, callback, window.location)

#-----------  Export  -----------#

module.exports = DataTableStore
