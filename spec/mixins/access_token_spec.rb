require 'spec_helper'

describe AccessToken do
  let(:user) { User.create(username: FFaker::Internet.user_name, encrypted_password: FFaker::Internet.password) }
  let(:client) { Client.create(name: FFaker::Internet.domain_word, redirect_uri: 'http://localhost:3000/home') }
  let(:scopes) { 'read write' }
  let(:access_token) { described_class.create_for(client, user, scopes) }

  context 'associations' do
    context '#client' do
      subject { access_token.client }

      it { is_expected.to eq client }
      it { is_expected.not_to be_nil }
    end

    context '#resource_owner' do
      subject { access_token.resource_owner }

      it { is_expected.to eq user }
      it { is_expected.not_to be_nil }
    end
  end

  context '#expired?' do
    subject { access_token.expired? }

    before { access_token.update(expires_at: Time.now - 604_800) } # - 7 days

    it { is_expected.to be_truthy }
  end

  context '#revoked?' do
    subject { access_token.revoked? }

    before { access_token.revoke! }

    it { is_expected.to be_truthy }
  end

  context '#revoke!' do
    subject { -> { access_token.revoke! } }

    it { is_expected.to change(access_token, :revoked_at).from(nil) }
  end

  context '#to_bearer_token' do
    subject { access_token.to_bearer_token }

    let(:to_bearer_token) do
      {
        access_token: access_token.token,
        expires_in: 7200,
        refresh_token: access_token.refresh_token,
        scope: 'read write'
      }
    end

    it { is_expected.to eq to_bearer_token }
  end

  context '.create_for' do
    subject { -> { access_token } }

    it { is_expected.to change(AccessToken, :count).from(0).to(1) }
  end

  context '.by_token' do
    subject { described_class.by_token(token) }

    let(:token) { access_token.token }

    it { is_expected.to eq access_token }
    it { is_expected.not_to be_nil }

    context 'when token is nil' do
      let(:token) {}

      it { is_expected.not_to eq access_token }
      it { is_expected.to be_nil }
    end
  end

  context '.by_refresh_token' do
    subject { described_class.by_refresh_token(refresh_token) }

    before { allow(Simple::OAuth2.config).to receive(:issue_refresh_token).and_return(true) }

    let(:refresh_token) { access_token.refresh_token }

    it { is_expected.to eq access_token }
    it { is_expected.not_to be_nil }

    context 'when refresh_token is nil' do
      let(:refresh_token) {}

      it { is_expected.not_to eq access_token }
      it { is_expected.to be_nil }
    end
  end

  context 'default value' do
    context 'for #token' do
      subject { access_token.token }

      it { is_expected.not_to be_nil }
    end

    context 'for refresh_token' do
      subject { access_token.refresh_token }

      context "if config 'issue_refresh_token' is true" do
        before { allow(Simple::OAuth2.config).to receive(:issue_refresh_token).and_return(true) }

        it { is_expected.to be_present }
      end

      context "if config 'issue_refresh_token' is true" do
        before { allow(Simple::OAuth2.config).to receive(:issue_refresh_token).and_return(false) }

        it { is_expected.to be_blank }
      end
    end

    context 'for #created_at' do
      subject { access_token.created_at }

      it { is_expected.not_to be_nil }
    end

    context 'for #updated_at' do
      subject { access_token.updated_at }

      it { is_expected.not_to be_nil }
    end
  end
end
