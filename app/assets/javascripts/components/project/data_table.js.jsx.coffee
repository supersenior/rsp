#-----------  Requirements  -----------#

DataTableStore      = require('stores/data_table')
LocalStorageAdapter = require('utils/local_storage_adapter')
isColumnVisible     = require('utils/utility_functions').isColumnVisible

SidebarCell     = require('components/project/table_cells/sidebar_cell')
ColumnCell      = require('components/project/table_cells/column_cell')
SidebarHeader   = require('components/project/table_cells/sidebar_header')
ColumnHeader    = require('components/project/table_cells/column_header')
SidebarFooter   = require('components/project/table_cells/sidebar_footer')
ColumnFooter    = require('components/project/table_cells/column_footer')
SidebarExtended = require('components/project/table_cells/sidebar_footer_extended')
ColumnExtended  = require('components/project/table_cells/column_footer_extended')

# for documentation on the Fixed Data Table components
# see https://facebook.github.io/fixed-data-table/

Table  = FixedDataTable.Table
Column = FixedDataTable.Column

#-----------  React Componet Class  -----------#

DataTable = React.createClass

  getInitialState: ->
    DataTableStore.init()

    return {
      currentProduct     : DataTableStore.getCurrentProduct()
      currentClass       : DataTableStore.getCurrentClass()
      showAdvanced       : DataTableStore.getAdvancedToggle()
      filteredRows       : DataTableStore.getFilteredRows()
      productVolume      : DataTableStore.getProductVolume()
      isFooterExpanded   : false
    }

  #-----------  Event Handlers  -----------#

  componentDidMount: ->
    DataTableStore.addChangeListener(@_onFilterChange)

  componentWillUnmount: ->
    DataTableStore.removeChangeListener(@_onFilterChange)

  # # Render Performance Tracking
  # componentDidUpdate: ->
  #   React.addons.Perf.stop()
  #   React.addons.Perf.printWasted()

  _onFilterChange: ->
    # React.addons.Perf.start()
    @setState
      currentProduct : DataTableStore.getCurrentProduct()
      currentClass   : DataTableStore.getCurrentClass()
      showAdvanced   : DataTableStore.getAdvancedToggle()
      filteredRows   : DataTableStore.getFilteredRows()
      productVolume  : DataTableStore.getProductVolume()

  _onFooterExpansion: ->
    @setState({ isFooterExpanded: !@state.isFooterExpanded })

  #-----------  Table Data Grabs  -----------#

  _rowGetter: (index) ->
    return @state.filteredRows[index]

  _headerDataGetter: ->
    return [@state.currentProduct, @state.currentClass, @state.showAdvanced]

  _footerDataGetter: ->
    return [@state.currentProduct, @state.productVolume]

  _rowHeightGetter: (index) ->
    return DataTableStore.calculateRowHieght(@state.filteredRows[index])

  _rowClassNameGetter: (index) ->
    row = @state.filteredRows[index]
    row_id = row.sidebar.row_id || null
    is_grouping_row = row.sidebar.is_grouping
    is_collapsed_row = LocalStorageAdapter.isRowCollapsed(row_id)

    return React.addons.classSet(
      'wt-tablerow'            : true
      'wt-tablerow--grouping'  : is_grouping_row
      'wt-tablerow--collapsed' : is_collapsed_row
    )

  _columnClassNameGetter: (column) ->
    return React.addons.classSet(
      'wt-tablecolumn'         : true
      'wt-tablecolumn--column' : true
      'wt-tablecolumn--hidden' : !isColumnVisible(column)
      'wt-tablecolumn--locked' : DataTableStore.hasSoldProposal() && !column.is_sold
      'wt-tablecolumn--sold'   : column.is_sold
    )

  #-----------  HTML Element Render  -----------#

  render: ->
    columnComponents = []

    for column, index in DataTableStore.getColumns()
      class_names           = @_columnClassNameGetter(column)
      column_data           = if _.isObject(column) then _.clone(column) else {}
      column_data.index     = index
      column_data.is_policy = (column_data.document_type == 'Policy') || false

      columnComponents.push(
        `<Column
          width={244}
          key={column_data.id}
          fixed={column_data.is_policy}
          dataKey={column_data.id}
          columnData={column_data}
          cellClassName={class_names}
          cellRenderer={this._getColumnCell}
          headerRenderer={this._getColumnHeader}
          footerRenderer={this.state.isFooterExpanded ? this._getColumnExtendedFooter : this._getColumnFooter}
        />`
      )

    footer_height = DataTableStore.calculateFooterHeight(@state.isFooterExpanded)

    return (
      `<Table
        rowHeight={50}
        headerHeight={125}
        footerHeight={footer_height}
        width={this.props.tableWidth}
        height={this.props.tableHeight}
        rowGetter={this._rowGetter}
        rowsCount={this.state.filteredRows.length}
        rowHeightGetter={this._rowHeightGetter}
        rowClassNameGetter={this._rowClassNameGetter}
        headerDataGetter={this._headerDataGetter}
        footerDataGetter={this._footerDataGetter}
        overflowX="auto"
        overflowY="auto"
      >

        <Column
          width={190}
          fixed={true}
          key="sidebar"
          dataKey="sidebar"
          label={this.state.currentClass}
          cellRenderer={this._getSidebarCell}
          headerRenderer={this._getSidebarHeader}
          footerRenderer={this.state.isFooterExpanded ? this._getSidebarExtendedFooter : this._getSidebarFooter}
        />

        {columnComponents}

        <Column
          width={25}
          key="buffer"
          dataKey="buffer"
        />

      </Table>`
    )

  #-----------  Sidebar Child Components  -----------#

  _getSidebarHeader: (label, cellDataKey, columnData, rowData, width) ->
    products        = DataTableStore.getProducts()
    orderedProducts = DataTableStore.getOrderedProducts()
    current_product = @state.currentProduct
    current_class   = @state.currentClass
    show_advanced   = @state.showAdvanced

    return (
      `<SidebarHeader
        products={products}
        orderedProducts={orderedProducts}
        currentProduct={current_product}
        currentClass={current_class}
        showAdvanced={show_advanced}
      />`
    )

  _getSidebarFooter: (label, cellDataKey, columnData, rowData, width) ->
    product_volume      = @state.productVolume
    is_contributory     = DataTableStore.isProductNonConributory()
    on_footer_expansion = @_onFooterExpansion

    return (
      `<SidebarFooter
        productVolume={product_volume}
        isContributory={is_contributory}
        onFooterExpansion={on_footer_expansion}
      />`
    )

  _getSidebarExtendedFooter: (label, cellDataKey, columnData, rowData, width) ->
    products            = DataTableStore.getNonContributoryProducts()
    rate_denominators   = DataTableStore.getProductDenominators()
    on_footer_expansion = @_onFooterExpansion

    return (
      `<SidebarExtended
        products={products}
        rateDenominators={rate_denominators}
        onFooterExpansion={on_footer_expansion}
      />`
    )

  _getSidebarCell: (cellData, cellDataKey, rowData, rowIndex, columnData, width) ->
    rowID        = cellData.row_id
    value        = cellData.value
    is_grouping  = cellData.is_grouping
    is_collapsed = LocalStorageAdapter.isRowCollapsed(cellData.row_id)

    return (
      `<SidebarCell
        key={rowID}
        rowID={rowID}
        value={value}
        isGrouping={is_grouping}
        isCollapsed={is_collapsed}
      />`
    )

  #-----------  Column Child Components  -----------#

  _getColumnHeader: (label, cellDataKey, columnData, rowData, width) ->
    column_id      = cellDataKey
    filenames      = columnData.source_filenames
    carrier_logo   = columnData.carrier?.logo_url
    carrier_name   = columnData.carrier?.name
    order_index    = columnData.index
    can_move_left  = columnData.index > DataTableStore.getLeftSortableBound()
    can_move_right = columnData.index < DataTableStore.getRightSortableBound()
    is_visible     = isColumnVisible(columnData)
    is_policy      = columnData.is_policy
    is_locked      = DataTableStore.hasSoldProposal()

    return (
      `<ColumnHeader
        columnID={column_id}
        filenames={filenames}
        carrierLogo={carrier_logo}
        carrierName={carrier_name}
        orderIndex={order_index}
        canMoveLeft={can_move_left}
        canMoveRight={can_move_right}
        isVisible={is_visible}
        isPolicy={is_policy}
        isLocked={is_locked}
      />`
    )

  _getColumnFooter: (label, cellDataKey, columnData, rowData, width) ->
    product_info = DataTableStore.getColumnsingleProductInformation(cellDataKey)

    unit_rate        = product_info.unit_rate
    rate_denominator = product_info.rate_denominator
    rate_guarantee   = product_info.rate_guarantee
    product_volume   = @state.productVolume
    comparison_rate  = DataTableStore.getComparisonRate()
    is_contributory  = product_info.is_contirbutory
    is_compact       = !DataTableStore.isProductNonConributory()
    is_visible       = isColumnVisible(columnData)
    is_policy        = columnData.is_policy

    return (
      `<ColumnFooter
        unitRate={unit_rate}
        rateDenominator={rate_denominator}
        rateGuarantee={rate_guarantee}
        productVolume={product_volume}
        comparisonRate={comparison_rate}
        isContributory={is_contributory}
        isCompact={is_compact}
        isVisible={is_visible}
        isPolicy={is_policy}
      />`
    )

  _getColumnExtendedFooter: (label, cellDataKey, columnData, rowData, width) ->
    product_info = DataTableStore.getColumnAllProductInformation(cellDataKey)

    column            = cellDataKey
    products          = DataTableStore.getNonContributoryProducts()
    unit_rates        = _.mapObject product_info, (info, id) -> return info.unit_rate
    rate_denominators = DataTableStore.getProductDenominators()
    rate_guarantees   = _.mapObject product_info, (info, id) -> return info.rate_guarantee
    contributory_data = _.mapObject product_info, (info, id) -> return info.is_contirbutory
    product_volumes   = LocalStorageAdapter.getProductVolumes()
    comparison_rates  = DataTableStore.getComparisonRates()
    is_visible        = isColumnVisible(columnData)
    is_policy         = columnData.is_policy

    return (
      `<ColumnExtended
        column={column}
        products={products}
        unitRates={unit_rates}
        rateDenominators={rate_denominators}
        rateGuarantees={rate_guarantees}
        contributoryData={contributory_data}
        productVolumes={product_volumes}
        comparisonRates={comparison_rates}
        isVisible={is_visible}
        isPolicy={is_policy}
      />`
    )

  _getColumnCell: (cellData, cellDataKey, rowData, rowIndex, columnData, width) ->
    is_visible   = isColumnVisible(columnData)

    value        = if is_visible then cellData.value else null
    column_id    = columnData.id
    attribute_id = if is_visible then cellData.id else null
    discrepency  = if is_visible then cellData.discrepency else null
    is_grouping  = rowData['sidebar'].is_grouping
    is_collapsed = LocalStorageAdapter.isRowCollapsed(rowData['sidebar'].row_id)
    is_policy    = columnData.is_policy

    return (
      `<ColumnCell
        key={attribute_id}
        value={value}
        columnID={column_id}
        attributeID={attribute_id}
        discrepency={discrepency}
        isCollapsed={is_collapsed}
        isGrouping={is_grouping}
        isVisible={is_visible}
        isPolicy={is_policy}
      />`
    )

#-----------  Export  -----------#

module.exports = DataTable
