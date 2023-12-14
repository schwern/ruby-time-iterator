# Inject 3.quarters
class Numeric
  def quarter
    (3 * self).months
  end
  alias quarters quarter
end
