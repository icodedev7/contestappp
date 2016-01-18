require 'spec_helper'

describe ShopifyController do

  let(:valid_session) { {} }
  before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account)
  end

  context "authorize" do

    it "should require the shop param" do
      get :authorize, {}, valid_session
      response.body.should == ":shop parameter required"

      get :authorize, {:shop => nil}, valid_session
      response.body.should == ":shop parameter required"

      get :authorize, {:shop => ""}, valid_session
      response.body.should == ":shop parameter required"

    end

    it "should redirect to the proper OAuth url" do
      get :authorize, {:shop => "test-shop.myshopify.com"}, valid_session
      response.should redirect_to("https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/oauth/authorize?client_id=2797f1bc7e2ae87a08fb90f0713f1712&scope=read_products,read_orders,read_customers,write_themes,write_script_tags,&redirect_uri=https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/apps/contestappp&state=Callback")

    end

     it "should redirect to the proper OAuth url" do
      get :authorize, {:shop => "devlopment-store"}, valid_session
      response.should redirect_to("https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/oauth/authorize?client_id=2797f1bc7e2ae87a08fb90f0713f1712&scope=read_products,read_orders,read_customers,write_themes,write_script_tags,&redirect_uri=https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/apps/contestappp&state=Callback")

    end

  end

  context "install" do

    before do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:any, "https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/oauth/access_token", :body => '{"access_token":""}')
      FakeWeb.register_uri(:any, "https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/shop.json", :body => '{"name":"devlopment-store", "id":""}')
      FakeWeb.register_uri(:any, "https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/webhooks.json", :body => '{"name":"devlopment-store", "id":""}')

      @shop_response = OpenStruct.new(name: "devlopment-store", id: 1231231, domain: "devlopment-store.com", shop_owner: "jyoti chauhan",
                                      email: "chauhan1234jyoti@gmail.com", address1: "Industrial Area, Phase 8", city: "chandigarh",
                                      province_code: "IN", province: "India", country: "india", zip: "160071",
                                      phone: "+91-8591178554", plan_name: "enterprise", timezone: "EST")

    end

    it "should verify the request" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      get :install, {:shop => "devlopment-store.myshopify.com", :code => ""}, valid_session
    end

    it "should render a message and return if verification fails" do

      ShopifyIntegration.should_receive(:verify).and_return(false)

      get :install, {:shop => "devlopment-store.myshopify.com", :code => ""}, valid_session
      response.body.should == "Unable to verify request"
    end

    it "should create a new Account (if one doesn't exist)" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      expect {get :install, {:shop => "devlopment-store.myshopify.com", :code => ""}, valid_session}.to change {Account.count}.by(1)
    end

    it "should update an existing account" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      account = FactoryGirl.create(:account, shopify_account_url: "devlopment-store.myshopify.com", shopify_password: "")
      get :install, {:shop => "devlopment-store.myshopify.com", :code => ""}, valid_session
      account.reload
      account.shopify_password.should == ""


    end


  end

end