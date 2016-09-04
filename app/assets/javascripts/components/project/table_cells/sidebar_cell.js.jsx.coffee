#-----------  Requirements  -----------#

DataTableActions = require('actions/data_table')
PureRenderMixin  = require('react/addons').addons.PureRenderMixin

#-----------  React Componet Class  -----------#

SidebarCell = React.createClass

  mixins: [PureRenderMixin]

  propTypes:
    rowID       : React.PropTypes.number
    value       : React.PropTypes.string.isRequired
    isGrouping  : React.PropTypes.bool
    isCollapsed : React.PropTypes.bool

  getDefaultProps: ->
    return {
      rowID       : null
      isCollapsed : false
      isGrouping  : false
    }

  #-----------  Event Handlers  -----------#

  _onCellClick: (evt) ->
    DataTableActions.toggleRowCollapse(@props.rowID, !@props.isCollapsed) unless @props.isGrouping

  #-----------  HTML Element Render  -----------#

  render: ->
    classes = React.addons.classSet(
      'wt-tablecell'            : true
      'wt-tablecell--sidebar'   : true
      'wt-tablecell--collapsed' : @props.isCollapsed
      'wt-tablecell--grouping'  : @props.isGrouping
    )

    return (
      `<div className={classes} onClick={this._onCellClick}>
        <span className="wt-tablecell__value">{this.props.value}</span>
      </div>`
    )

#-----------  Export  -----------#

module.exports = SidebarCell
