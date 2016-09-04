#-----------  Requirements  -----------#

isUsableNumber   = require('utils/utility_functions').isUsableNumber
currencyFormater = require('utils/utility_functions').currencyFormater
PureRenderMixin  = require('react/addons').addons.PureRenderMixin

#-----------  React Componet Class  -----------#

ColumnFooter = React.createClass

  mixins: [PureRenderMixin]

  propTypes:
    unitRate        : React.PropTypes.number
    rateDenominator : React.PropTypes.number
    rateGuarantee   : React.PropTypes.any
    productVolume   : React.PropTypes.string
    comparisonRate  : React.PropTypes.number
    isContributory  : React.PropTypes.bool
    isCompact       : React.PropTypes.bool
    isVisible       : React.PropTypes.bool
    isPolicy        : React.PropTypes.bool

  getDefaultProps: ->
    return {
      unitRate        : 0
      rateDenominator : null
      rateGuarantee   : 0
      productVolume   : null
      comparisonRate  : 0
      isContributory  : null
      isCompact       : true
      isVisible       : false
      isPolicy        : false
    }

  #-----------  HTML Element Render  -----------#

  render: ->
    classes = React.addons.classSet(
      'wt-footercell'               : true
      'wt-footercell--column'       : true
      'wt-footercell--sticky'       : @props.isPolicy
      'wt-footercell--contributory' : @props.isContributory
      'wt-footercell--compact'      : @props.isCompact
      'wt-footercell--hidden'       : !@props.isVisible
    )

    #-----------  Quick Defaults  -----------#

    if !@props.isVisible
      return (`<div className={classes}></div>`)

    if @props.isCompact
      if @props.isPolicy
        cellFooter = (
          `<div className="wt-footercell__footer">
            <div className="wt-footercell__data-row">
              Current Policy
              <small><i className="icon-lock"></i></small>
            </div>
          </div>`
        )
      else
        cellFooter = (
          `<div className="wt-footercell__footer">
          </div>`
        )
      return (`<div className={classes}>{cellFooter}</div>`)

    #-----------  Calculations  -----------#

    unit_rate         = parseFloat(@props.unitRate)
    rate_denomination = parseInt(@props.rateDenominator)
    product_volume    = parseInt(@props.productVolume)
    unit_basis        = (product_volume / rate_denomination) || null

    #-----------  Main Content  -----------#

    if @props.isContributory == true
      unitContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div><em>contributory product</em></div>
          </div>
        </div>`
      )
    else if isUsableNumber(unit_rate) && isUsableNumber(unit_basis)
      monthly_total = currencyFormater(unit_rate * unit_basis)
      yearly_total  = currencyFormater(unit_rate * unit_basis * 12)

      unitContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            ${unit_rate.toFixed(3)} / {this.props.rateGuarantee} mo
            <small>/${this.props.rateDenominator}</small>
          </div>
        </div>`
      )
      monthylContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div>{monthly_total}</div>
            <small>/mo</small>
          </div>
        </div>`
      )
      yearlyContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div>{yearly_total}</div>
            <small>/yr</small>
          </div>
        </div>`
      )
    else if isUsableNumber(unit_rate) && isUsableNumber(rate_denomination)
      unitContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            ${unit_rate.toFixed(3)} / {this.props.rateGuarantee} mo
            <small>/${this.props.rateDenominator}</small>
          </div>
        </div>`
      )
      monthylContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <em>volume not entered yet</em><small>/mo</small>
          </div>
        </div>`
      )
      yearlyContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <em>volume not entered yet</em><small>/yr</small>
          </div>
        </div>`
      )
    else if _.isBoolean(@props.isContributory)
      unitContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div><em>no rate provided</em></div>
          </div>
        </div>`
      )
    else
      unitContent = (
        `<div className="wt-footercell__content">
          <div className="wt-footercell__data-row">
            <div>&nbsp;</div>
          </div>
        </div>`
      )

    #-----------  Footer Content  -----------#

    if @props.isPolicy
      cellFooter = (
        `<div className="wt-footercell__footer">
          <div className="wt-footercell__data-row">
            Current Policy
            <small><i className="icon-lock"></i></small>
          </div>
        </div>`
      )
    else if @props.isContributory || !@props.comparisonRate || !isUsableNumber(unit_rate)
      cellFooter = (
        `<div className="wt-footercell__footer">
          &nbsp;
        </div>`
      )
    else if @props.productVolume && unit_basis
      comparison_rate       = parseFloat(@props.comparisonRate)
      difference_percentage = (((unit_rate - comparison_rate) / comparison_rate) * 100)
      difference_value      = currencyFormater(((unit_rate * unit_basis) - (comparison_rate * unit_basis)) * 12)
      difference_symbol     = if (difference_percentage > 0) then '+' else ''
      difference_color      = if (difference_percentage > 0) then 'red' else 'green'
      difference_class      = "wt-footercell__footer wt-footercell__footer--#{difference_color}"

      cellFooter = (
        `<div className={difference_class}>
          <div className="wt-footercell__data-row">
            {difference_symbol}{difference_percentage.toFixed(1)}% &nbsp; &nbsp; {difference_symbol}{difference_value}
            <small>/yr</small>
          </div>
        </div>`
      )
    else
      cellFooter = (
        `<div className="wt-footercell__footer">
          <div className="wt-footercell__data-row">
            0% &nbsp; &nbsp; $0
            <small>/yr</small>
          </div>
        </div>`
      )

    #-----------  Final Output  -----------#

    return (
      `<div className={classes}>
        {unitContent}

        {monthylContent}

        {yearlyContent}

        {cellFooter}
      </div>`
    )

#-----------  Export  -----------#

module.exports = ColumnFooter
