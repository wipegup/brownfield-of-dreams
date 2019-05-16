require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:password) }
  end

  describe 'roles' do
    it 'can be created as default user' do
      user = User.create(email: 'user@email.com',
                         password: 'password',
                         first_name: 'Jim',
                         role: 0)

      expect(user.role).to eq('default')
      expect(user.default?).to be_truthy
    end

    it 'can be created as an Admin user' do
      admin = User.create(email: 'admin@email.com',
                          password: 'admin',
                          first_name: 'Bob',
                          role: 1)

      expect(admin.role).to eq('admin')
      expect(admin.admin?).to be_truthy
    end
  end

  describe 'instance methods' do
    it '.active?' do
      user = create(:user)
      activation = create(:activation, user: user)

      expect(user.active?).to eq(false)

      activation.status = true
      activation.save
      user.reload

      expect(user.active?).to eq(true)
    end

    it '.generate_activation' do
      user = create(:user)

      expect(user.activations.count).to eq(0)

      email_code = user.generate_activation

      expect(user.activations.count).to eq(1)
      expect(user.activations.first.email_code).to eq(email_code)
    end
  end
end
