require 'rails_helper'

RSpec.describe SendEmailsJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    let(:user) { create(:user) }
    let(:email_type) { 'welcome' }

    it 'enqueues the job' do
      expect {
        SendEmailsJob.perform_later(user.id, email_type)
      }.to have_enqueued_job(SendEmailsJob)
        .with(user.id, email_type)
        .on_queue('default')
    end

    it 'sends the correct email' do
      expect(UserMailer).to receive(:send).with(email_type, user).and_call_original

      perform_enqueued_jobs do
        SendEmailsJob.perform_later(user.id, email_type)
      end
    end
  end
end
