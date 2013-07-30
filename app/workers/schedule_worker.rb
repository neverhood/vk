class ScheduleWorker
  include Sidekiq::Worker

  def perform(schedule_id)
    @schedule = Schedule.find(schedule_id)
    puts Schedule.count

    @schedule.publish_now!
  end
end
