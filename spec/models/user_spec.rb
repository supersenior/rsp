require 'rails_helper'

def build_user(email, password)
  User.new email: email,
           password: password,
           password_confirmation: password
end

def create_user(email, password)
  user = build_user(email, password)
  user.save
  user
end

describe User, '.authenticate' do
  it 'returns nil if the email is not found' do
    expect(User.authenticate('email', 'pass')).to be_nil
  end

  it 'returns nil if the email is found but the password is incorrect' do
    email, password = 'super@user.com', 'password'
    user = create_user(email, password)

    expect(User.authenticate(email, 'notpassword')).to be_nil
  end

  it 'returns the user if the email is found AND the password is correct' do
    email, password = 'super@user.com', 'password'
    user = create_user(email, password)

    expect(User.authenticate(email, password)).to eql(user)
  end
end

describe User, 'working with AR callbacks' do
  it 'downcases the email before save' do
    user = User.new email: 'EMAIL', password: 'password'

    expect {
      user.save
    }.to change(user, :email).to('email')
  end
end

describe User, '#encrypt_password' do
  it 'does NOT change password_salt if password is not present' do
    user = User.new

    expect {
      user.save
    }.to_not change(user, :password_salt)
  end

  it 'does NOT change password_hash if password is not present' do
    user = User.new

    expect {
      user.save
    }.to_not change(user, :password_hash)
  end

  it 'generates a new password_salt when password is present' do
    user = build_user('email@email.com', 'password')

    expect {
      user.save
    }.to change(user, :password_salt).from(nil)
  end

  it 'generates a new password_hash when password is present' do
    user = build_user('email@email.com', 'password')

    expect {
      user.save
    }.to change(user, :password_hash).from(nil)
  end
end

describe User, '#all_projects' do
  it 'queries for projects owned by the user only when user IS NOT an org admin' do
    user = create_user('email@email.com', 'password')
    project = create(:project, user: user)

    expect(user.all_projects.to_a).to eql([project])
  end

  it 'queries for projects owned by all org users when user IS an org admin' do
    organization = Organization.create name: 'Super Fun People'

    boss_lady = organization.users.create email: 'boss@email.com', password: 'password'
    boss_lady.add_role(:org_admin)
    servant = organization.users.create email: 'wimpy@email.com', password: 'serve4life'

    boss_project = create(:project, user: boss_lady)
    servant_project = create(:project, user: servant)

    expect(boss_lady.all_projects.to_a).to eql([boss_project, servant_project])
    expect(servant.all_projects.to_a).to eql([servant_project])
  end
end
