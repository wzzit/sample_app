require 'spec_helper'

describe User do
	subject { User.new(name: "Example User", email: "user@user.com", 
						password: "foobar", password_confirmation: "foobar") }
	invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com] 
	valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn] 

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:email) }
	it { should_not allow_value("a" * 51).for(:name) }
	it { should_not allow_value("a" * 5).for(:password) }
	it { should_not allow_value(" ").for(:password) }
	it { should_not allow_value(" ").for(:password_confirmation) }
	it { should_not allow_value(nil).for(:password_confirmation) }
	it { should validate_uniqueness_of(:email) }

	invalid_addresses.each do |address|
		it { should_not allow_value(address).for(:email) }
	end

	valid_addresses.each do |address|
		it { should allow_value(address).for(:email) }
	end

	describe "return value of an authenticate method" do
		before { @user = User.create!(name: "Young", email: "young@young.com",
														 password: "blahblah", password_confirmation: "blahblah") }
		let(:found_user) { User.find_by_email(@user.email) }
		let(:user_for_invalid_password) { found_user.authenticate("invalid") }

		context "with valid password" do
			it "should match the found user's password" do
				@user.should eq found_user.authenticate(@user.password)
			end
		end

		context "with invalid password" do
			it "should not match the user for invalid password" do
				@user.should_not eq user_for_invalid_password
			end

			specify { user_for_invalid_password.should be_false }
		end
	end
end
