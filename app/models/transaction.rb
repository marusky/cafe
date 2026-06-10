class Transaction
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :amount, :sender

  CURRENCY = "EUR"
  REFERRENCE = "tamcafe2026"

  validates :amount, :sender, presence: true

  def link
    "https://payme.sk/2/p/PME?" + link_params.to_query
  end

  private
    def link_params
      {
        iban: iban,
        cn: payee,
        am: amount,
        msg: sender,
        pi: REFERRENCE,
        cc: CURRENCY,
        dt: current_date
    }.transform_keys(&:upcase)
    end

    def iban
      Cafe.first.iban
    end

    def payee
      Cafe.first.payee
    end

    def current_date
      Date.current.strftime("%Y%m%d")
    end
end
