require "spec_helper"

describe UsersMailer do
  describe "forget_password_email" do
    let(:mail) { UsersMailer.forget_password_email }

    it "renders the headers" do
      mail.subject.should eq("Forget password email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "signup_email" do
    let(:mail) { UsersMailer.signup_email }

    it "renders the headers" do
      mail.subject.should eq("Signup email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "friend_request_email" do
    let(:mail) { UsersMailer.friend_request_email }

    it "renders the headers" do
      mail.subject.should eq("Friend request email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
