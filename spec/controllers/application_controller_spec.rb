RSpec.describe ApplicationController do

	describe "Homepage" do
		it 'renders homepage' do
			get '/'
			expect(last_response.status).to eq(200)
			expect($total_accounts).to eq(Account.all.length)
			expect($accounts).to eq(Account.all)
			expect($total_debt).to eq(Account.sum(:principal))
		end
	end
end
