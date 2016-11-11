RSpec.shared_examples 'user is not authorized' do |verb, action|
  it "#{action} returns 401 when when not authorized" do
    process action, method: verb, params: { id: 0 }
    expect(response).to have_http_status(401)
    expect(response.body).to eq(I18n.t("errors.user.non_authorized"))
  end
end