#-----------  Requirements  -----------#

DataTable = require('components/project/data_table')

#-----------  React Componet Class  -----------#

DashboardWrapper = React.createClass

  getInitialState: ->
    return {
      renderPage  : false
      tableWidth  : 500
      tableHeight : 500
    }

  componentDidMount: ->
    @_updateSizing()
    @_addResizeListeners()

  #-----------  Sizing / Scrolling Helpers  -----------#

  _addResizeListeners: ->
    $(window).on 'resize sidebar:toggle', @_onResize

  _onResize: ->
    clearTimeout(@_updateTimer)
    @_updateTimer = setTimeout(@_updateSizing, 16)

  _updateSizing: ->
    @setState({
      renderPage  : true
      tableWidth  : $('.wt-page-content__main').width()
      tableHeight : $('.wt-page-content__main').height()
    })

  #-----------  HTML Element Render  -----------#

  render: ->
    return (
      `<DataTable {...this.state} />`
    )

#-----------  Export  -----------#

module.exports = DashboardWrapper
window.DashboardWrapper = DashboardWrapper
