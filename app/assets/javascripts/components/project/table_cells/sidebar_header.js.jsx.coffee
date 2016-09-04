#-----------  Requirements  -----------#

DataTableActions = require('actions/data_table')
ToggleSwitch     = require('components/common/toggle_switch')
PureRenderMixin  = require('react/addons').addons.PureRenderMixin

#-----------  React Componet Class  -----------#

SidebarHeader = React.createClass

  mixins: [PureRenderMixin]

  propTypes:
    products       : React.PropTypes.object.isRequired
    currentProduct : React.PropTypes.string.isRequired
    currentClass   : React.PropTypes.string.isRequired
    showAdvanced   : React.PropTypes.bool

  getDefaultProps: ->
    return { showAdvanced: false }

  #-----------  Event Handlers  -----------#

  _onProductSelection: (evt) ->
    selectedProduct = evt.target.value
    selectedClass   = _.keys(@props.products[selectedProduct].product_classes)[0]
    showAdvanced    = null

    DataTableActions.changeFilters(selectedProduct, selectedClass, showAdvanced)

  _onClassSelection: (evt) ->
    selectedProduct = @props.currentProduct
    selectedClass   = evt.target.value
    showAdvanced    = @props.showAdvanced

    DataTableActions.changeFilters(selectedProduct, selectedClass, showAdvanced)

  _onAdvancedToggle: (evt) ->
    selectedProduct = @props.currentProduct
    selectedClass   = @props.currentClass
    showAdvanced    = !@props.showAdvanced

    DataTableActions.changeFilters(selectedProduct, selectedClass, showAdvanced)

  #-----------  HTML Element Render  -----------#

  render: ->
    classes = React.addons.classSet(
      'wt-headercell'          : true
      'wt-headercell--sidebar' : true
    )

    productOptions = []
    classOptions   = []

    for product in @props.orderedProducts
      is_disabled = product.is_empty
      productOptions.push `<option value={product.product_id} key={product.product_id} disabled={is_disabled}>{product.name}</option>`

    for klass_id, klass of @props.products[@props.currentProduct].product_classes
      is_disabled = klass.is_empty
      classOptions.push `<option value={klass_id} key={klass_id} disabled={is_disabled}>{klass.name}</option>`

    return (
      `<div className={classes}>
        <ToggleSwitch
          label="Advanced View"
          isChecked={this.props.showAdvanced}
          onClick={this._onAdvancedToggle}
        />

        <div className="select-wrapper">
          <select
            value={this.props.currentProduct}
            onChange={this._onProductSelection}
          >
            {productOptions}
          </select>
        </div>

        <div className="select-wrapper">
          <select
            value={this.props.currentClass}
            onChange={this._onClassSelection}
          >
            {classOptions}
          </select>
        </div>
      </div>`
    )

#-----------  Export  -----------#

module.exports = SidebarHeader
