require 'rails_helper'

RSpec.describe SendEmailJob, type: :job do
  before{
    @user = create(:user)
  }
  describe "#perform" do
    it "send mail" do
      ActiveJob::Base.queue_adapter = :test
      expect{
        SendEmailJob.set(wait: 2.seconds).perform_later(@user.id)
      }.to have_enqueued_job
    end
  end
end
