Braintree::Configuration.environment  = ENV['BRAINTREE_ENV']         || :sandbox
Braintree::Configuration.merchant_id   = ENV['BRAINTREE_MERCHANT_ID'] || '944vn99rpf23stck'
Braintree::Configuration.public_key   = ENV['BRAINTREE_PUBLIC_KEY']  || 'jcz5zvwxn56xv3d5'
Braintree::Configuration.private_key  = ENV['BRAINTREE_PRIVATE_KEY'] || '0099c17913265c78a85cfd8195ec66dc'