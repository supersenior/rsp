class Metlife < Parser
  SELECTORS = {
    sic_code: "body > table:nth-child(172) > tbody > tr:nth-child(5) > td > p > span",
    effective_date: "body > p:nth-child(19)",
    proposal_duration: "body > p:nth-child(20)"
  }

  def initialize(filepath)
    html = Parser.html_from_file(filepath)

    super(html)
  end
end
