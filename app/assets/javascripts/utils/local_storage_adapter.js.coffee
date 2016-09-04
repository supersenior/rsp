#-----------  Module  -----------#

LocalStorageAdapter =

  _project_id : ''
  _rows       : 'collapsed_rows'
  _advanced   : 'advanced_products'
  _volumes    : 'product_volumes'
  _sorting    : 'sorted_columns'

  storageInitialization: (project_id = 0) ->
    @_project_id = project_id

    @_initialize_rows()
    @_initialize_advanced()
    @_initialize_volumes()
    @_initialize_sorting()

  #-----------  Project Data  -----------#

  getAllProjectData: (project_id = 0) ->
    @_project_id = project_id

    return {
      rows     : @_getValues(@_rows)
      advanced : @_getValues(@_advanced)
      volumes  : @_getValues(@_volumes)
      sorting  : @_getValues(@_sorting)
    }

  #-----------  I/O  -----------#

  _getValues: (type) ->
    return JSON.parse(localStorage.getItem("#{@_project_id}-#{type}"))

  _setValues: (type, values) ->
    return localStorage.setItem("#{@_project_id}-#{type}", JSON.stringify(values))

  #-----------  Collapsed Row Methods  -----------#

  _initialize_rows: ->
    rows = @_getValues(@_rows)
    @_setValues(@_rows, []) unless (_.isArray(rows))

  isRowCollapsed: (row_id) ->
    rows = @_getValues(@_rows)
    return (_.indexOf(rows, row_id) != -1)

  toggleCollapsedRow: (row_id, is_collapsed) ->
    rows = @_getValues(@_rows)
    if is_collapsed
      rows.push(row_id)
    else
      rows = _.without(rows, row_id)
    return @_setValues(@_rows, _.unique(rows))

  #-----------  Advanced Toggle Methods  -----------#

  _initialize_advanced: ->
    advanced = @_getValues(@_advanced)
    @_setValues(@_advanced, []) unless (_.isArray(advanced))

  isAdvancedProduct: (product_id) ->
    advanced = @_getValues(@_advanced)
    return (_.indexOf(advanced, product_id) != -1)

  toggleAdvancedProduct: (product_id, is_advanced) ->
    advanced = @_getValues(@_advanced)
    if is_advanced
      advanced.push(product_id)
    else
      advanced = _.without(advanced, product_id)
    return @_setValues(@_advanced, _.unique(advanced))

  #-----------  Product Volume Methods  -----------#

  _initialize_volumes: ->
    volumes = @_getValues(@_volumes)
    @_setValues(@_volumes, {}) unless (_.isObject(volumes))

  getProductVolumes: ->
    return @_getValues(@_volumes)

  getProductVolume: (product_id) ->
    volumes = @_getValues(@_volumes)
    return volumes[product_id] || null

  setProductVolume: (product_id, volume) ->
    volumes = @_getValues(@_volumes)
    volumes[product_id] = volume
    return @_setValues(@_volumes, volumes)

  #-----------  Column Sorting Methods  -----------#

  _initialize_sorting: ->
    sorting = @_getValues(@_sorting)
    @_setValues(@_sorting, []) unless (_.isObject(sorting))

  getColumnsorting: ->
    return @_getValues(@_sorting)

  setColumnSorting: (sorting) ->
    return @_setValues(@_sorting, sorting)

  resortColumns: (column_id, from_index, to_index, columns) ->
    sorting = @_getValues(@_sorting)
    sorting = _.map(columns, (column) -> column.id) if _.isEmpty(sorting)
    sorting.splice(to_index, 0, sorting.splice(from_index, 1)[0])
    return @setColumnSorting(sorting)

#-----------  Export  -----------#

module.exports = LocalStorageAdapter
