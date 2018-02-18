require 'spec_helper'

describe Client do
  let(:client) do
    described_class.create(
      name: FFaker::Internet.domain_word,
      redirect_uri: 'http://localhost:3000/home'
    )
  end
  let(:key) { client.key }

  context 'associations' do
    let(:scopes) {}
    let(:redirect_uri) { client.redirect_uri }
    let(:user) { User.create(username: FFaker::Internet.user_name, encrypted_password: FFaker::Internet.password) }

    context '#access_tokens' do
      subject { client.access_tokens }

      let!(:access_token) { AccessToken.create_for(client, user, scopes) }

      it { is_expected.to include(access_token) }
      it { is_expected.not_to be_empty }
    end

    context '#access_grants' do
      subject { client.access_grants }

      let!(:access_grant) { AccessGrant.create_for(client, user, redirect_uri, scopes) }

      it { is_expected.to include(access_grant) }
      it { is_expected.not_to be_empty }
    end
  end

  context 'default value' do
    context 'for #key' do
      subject { client.key }

      it { is_expected.not_to be_nil }
    end

    context 'for #secret' do
      subject { client.secret }

      it { is_expected.not_to be_nil }
    end

    context 'for #created_at' do
      subject { client.created_at }

      it { is_expected.not_to be_nil }
    end

    context 'for #updated_at' do
      subject { client.updated_at }

      it { is_expected.not_to be_nil }
    end
  end

  context '.by_key' do
    subject { described_class.by_key(key) }

    context 'when param is present' do
      it { is_expected.to eq client }
      it { is_expected.not_to be_nil }
    end

    context 'when param is blank' do
      let(:key) {}

      it { is_expected.not_to eq client }
      it { is_expected.to be_nil }
    end
  end
end
