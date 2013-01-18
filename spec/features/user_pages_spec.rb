require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "Sign up page" do
		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign up') }
		it { should have_selector('title', content: full_title('Sign up'))}
	end
end