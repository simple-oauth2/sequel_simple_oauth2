require 'spec_helper'

describe User do
  let(:user) { User.create(username: FFaker::Internet.user_name, encrypted_password: FFaker::Internet.password) }
  let(:username) { user.username }
  let(:password) { user.encrypted_password }
  let(:_client) {}

  context '.oauth_authenticate' do
    subject { described_class.oauth_authenticate(_client, username, password) }

    it { is_expected.to eq user }
    it { is_expected.not_to be_nil }

    context 'when username is nil' do
      let(:username) {}

      it { is_expected.to be_nil }
    end

    context 'when password is nil' do
      let(:password) {}

      it { is_expected.to be_nil }
    end
  end

  context 'default value' do
    context 'for #created_at' do
      subject { user.created_at }

      it { is_expected.not_to be_nil }
    end

    context 'for #updated_at' do
      subject { user.updated_at }

      it { is_expected.not_to be_nil }
    end
  end
end
