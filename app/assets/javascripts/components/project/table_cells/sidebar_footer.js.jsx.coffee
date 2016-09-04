#-----------  Requirements  -----------#

DataTableActions = require('actions/data_table')
PureRenderMixin  = require('react/addons').addons.PureRenderMixin

#-----------  React Componet Class  -----------#

SidebarFooter = React.createClass

  mixins: [PureRenderMixin]

  propTypes:
    productVolume     : React.PropTypes.string
    isContributory    : React.PropTypes.bool
    onFooterExpansion : React.PropTypes.func

  #-----------  Event Handlers  -----------#

  _onVolumeChange: (evt) ->
    DataTableActions.changeProductVolume(evt.target.value)

  #-----------  HTML Element Render  -----------#

  render: ->
    classes = React.addons.classSet(
      'wt-footercell'               : true
      'wt-footercell--sidebar'      : true
      'wt-footercell--contributory' : @props.isContributory
    )

    #-----------  Main Content  -----------#

    if @props.isContributory
      cellContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div className="wt-footercell__title">Product Cost Analysis</div>
            <span>Volume</span>
            <input type="number" value={this.props.productVolume} onChange={this._onVolumeChange} min="0" max="999999999999" step="1" placeholder="enter volume" />
          </div>
        </div>`
      )
    else
      cellContent = ''

    #-----------  Footer Content  -----------#

    if @props.isContributory
      cellFooter = (
        `<div className="wt-footercell__footer">
          <div className="wt-footercell__expand-button" onClick={this.props.onFooterExpansion}>
            View Total Costs
            <i className="icon-up"></i>
          </div>
        </div>`
      )
    else
      cellFooter = ''

    #-----------  Final Output  -----------#

    return (
      `<div className={classes}>
        {cellContent}
        {cellFooter}
      </div>`
    )

#-----------  Export  -----------#

module.exports = SidebarFooter