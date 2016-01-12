ShopifyApp.configure do|config|
config.api_key="2797f1bc7e2ae87a08fb90f0713f1712"
config.secret="756bbb6132cc61ad450e5b1bd2e0f411"
config.redirect_uri="https://contestappp.herokuapp.com/auth/shopify/callback"
config.scope="read_orders, read_products"
config.embedded_app=true
end
