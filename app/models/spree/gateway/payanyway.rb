module Spree
  class Gateway::Payanyway < Gateway
    preference :payanyway_shop_id, :string
    preference :payanyway_currency_code, :string, :default => 'RUB'
    preference :payanyway_signature, :string
    preference :payanyway_locale, :string, :default => 'ru'
    preference :payanyway_payment_system, :string
    preference :payanyway_payment_system_list, :string

    def provider_class
      self.class
    end

    def method_type
      'payanyway'
    end

    def mode
      test? ? 1 : 0
    end

    def test?
      options[:test_mode] == true
    end

    def url
      self.test? ? 'https://demo.moneta.ru/assistant.htm' : 'https://www.payanyway.ru/assistant.htm'
    end

    def self.current
      self.where(:type => self.to_s, :active => true).first
    end

    def source_required?
      false
    end    

    def desc
      "<p>
        <label> #{Spree.t('payanyway.success_url')}: </label> #{root_url}/gateway/payanyway/success<br />
        <label> #{Spree.t('payanyway.result_url')}: </label> #{root_url}/gateway/payanyway/result<br />
        <label> #{Spree.t('payanyway.fail_url')}: </label> #{root_url}/gateway/payanyway/fail<br />
      </p>"
    end    

    def signature( order ) 
      Digest::MD5.hexdigest([ options[:id], 
        order.id, format("%.2f", order.total), 
        options[:currency_code], 
        mode, options[:signature] ].join).downcase
    end

  end
end
