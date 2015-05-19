require 'rails_helper'

describe User do
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_length_of(:username).is_at_least(2) }
  it { should validate_length_of(:password).is_at_least(5).on(:create) }
  it { should validate_presence_of(:password).on(:create) }
  it { should allow_value("", nil).for(:password).on(:update) }
  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }


  describe '#generate_token!' do
    it 'saves a randomly generated token into the user token' do
      bob = Fabricate(:user)
      bob.generate_token!
      expect(bob.account_token).to be_present
    end
  end
  
  describe '#generate_slug' do
    it 'downcase all the characters' do
      bob = Fabricate(:user, username: 'ASDFG')
      expect(bob.generate_slug!).to eq('asdfg')
    end

    it 'strips the username of spaces and special characters with "-"' do
      bob = Fabricate(:user, username: 'aasf s 23!@3>?')
      expect(bob.generate_slug!).to eq('aasf-s-23-3-')
    end

    it 'saves the slug into the db when a user is created' do
      bob = Fabricate(:user, username: 'Slug!123')
      expect(bob.reload.slug).to eq('slug-123')
    end
  end

  describe '#to_param' do
    it "returns the user's slug" do
      bob = Fabricate(:user)
      expect(bob.reload.to_param).to eq(bob.slug)
    end
  end
end