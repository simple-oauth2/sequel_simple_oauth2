require 'spec_helper'

describe AccessGrant do
  let(:user) { User.create(username: FFaker::Internet.user_name, encrypted_password: FFaker::Internet.password) }
  let(:client) { Client.create(name: FFaker::Internet.domain_word, redirect_uri: 'http://localhost:3000/home') }
  let(:redirect_uri) { client.redirect_uri }
  let(:scopes) { 'read write' }
  let(:access_grant) { described_class.create_for(client, user, redirect_uri, scopes) }

  context 'associations' do
    context '#client' do
      subject { access_grant.client }

      it { is_expected.to eq client }
      it { is_expected.not_to be_nil }
    end

    context '#resource_owner' do
      subject { access_grant.resource_owner }

      it { is_expected.to eq user }
      it { is_expected.not_to be_nil }
    end
  end

  context '.create_for' do
    subject { -> { access_grant } }

    it { is_expected.to change(AccessGrant, :count).from(0).to(1) }
  end

  context '.by_token' do
    subject { described_class.by_token(token) }

    let(:token) { access_grant.token }

    it { is_expected.to eq access_grant }
    it { is_expected.not_to be_nil }

    context 'when token is nil' do
      let(:token) {}

      it { is_expected.not_to eq access_grant }
      it { is_expected.to be_nil }
    end
  end

  context 'default value' do
    context 'for #token' do
      subject { access_grant.token }

      it { is_expected.to eq access_grant.token }
      it { is_expected.not_to be_nil }
    end

    context 'for #expires_at' do
      subject { access_grant.expires_at }

      it { is_expected.not_to be_nil }
    end

    context 'for #created_at' do
      subject { access_grant.created_at }

      it { is_expected.not_to be_nil }
    end

    context 'for #updated_at' do
      subject { access_grant.updated_at }

      it { is_expected.not_to be_nil }
    end
  end
end
