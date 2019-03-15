require 'rails_helper'
RSpec.describe EmailWorker, type: :worker do
  before{
    @user = create(:user)
  }
  describe "#perform" do
    it "send mail" do
      ActiveJob::Base.queue_adapter = :sidekiq
      expect{
        EmailWorker.perform_async(@user.id)
      }.to change(EmailWorker.jobs, :size).by(1)
    end
  end
end
