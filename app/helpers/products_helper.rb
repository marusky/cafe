module ProductsHelper
  def humanized_price(amount)
    case amount
    when 1
      '1 žetón'
    when 2..4
      "#{amount} žetóny"
    else
      "#{amount} žetónov"
    end
  end
end
