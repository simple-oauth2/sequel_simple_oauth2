require 'spec_helper'

describe User do
  let(:user) { User.new(username: FFaker::Internet.user_name, encrypted_password: generate_password) }
  let(:pass) { Resource::GeneratePassword::DEFAULT_PASSWORD }

  context 'validations' do
    let(:pass) {}
    let(:pass_confirmation) {}

    subject do
      user.password = pass
      user.password_confirmation = pass_confirmation
      user.valid?
      user.errors
    end

    context 'when password is nil' do
      let(:error) { { :password => ["is not present"] } }

      it { is_expected.to eq error }
    end

    context 'when passord is nil & password_confirmation is present' do
      let(:pass_confirmation) { 'password' }
      let(:error) do
        {
          :password => ["is not present"],
          :password_confirmation => ["must match with password"]
        }
      end

      it { is_expected.to eq error }
    end

    context 'when password is present & password_confirmation is not correct' do
      let(:pass) { Resource::GeneratePassword::DEFAULT_PASSWORD }
      let(:pass_confirmation) { 'foo' }
      let(:error) { { :password_confirmation => ["must match with password"] } }

      it { is_expected.to eq error }
    end

    context 'when password of length more than 72 characters' do
      let(:generate_password) { '1' * 75 }
      let(:pass) { generate_password }

      it { expect { subject }.to raise_error(ArgumentError, /Password is longer than 72 characters/) }
    end
  end

  context '#authenticate' do
    subject { user.authenticate(pass) }

    it { is_expected.to eq user }
    it { is_expected.not_to be_nil }

    context 'when password is nil' do
      let(:pass) {}

      it { is_expected.to be_falsey }
    end
  end

  context '#password' do
    subject { user.password }

    it { is_expected.not_to be_nil }
    it { is_expected.to eq pass }
  end

  context '#password=' do
    context 'when password is present' do
      let(:new_pass) { 'foo' }

      subject do
        user.password = new_pass
        user.save
        user.password
      end

      it { is_expected.to eq new_pass }
      it { is_expected.not_to eq pass }
    end

    context 'when password is nil' do
      let(:new_pass) {}
      let(:error) { { :password => ["is not present"] } }

      subject do
        user.password = new_pass
        user.valid?
        user.errors
      end

      it { is_expected.to eq error }
    end
  end

  context '#min_cost?' do
    subject { user.min_cost? }

    it { is_expected.to be_falsey }
  end

  context 'default value' do
    before { user.save }

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
